
local Milling = {};
FCF.Milling = Milling;

local itemID = 191461
local MillingSpells = { [444181] = "TWW" , [382981] = "DF" , [382982] = "SL" , [382984] = "BFA" , [382986] = "LG" , [382987] = "WOD" , [382988] = "PANDA" , [382989] = "CATA" , [382990] = "WOTLK" , [382991] = "TBC" , [382994] = "CLASSIC"  }
local combiningHerbs = false;

HerbsEnum = {
    ["CLASSIC"] = {
        [765] = true , [785] = true , [2447] = true , [2449] = true , [2450] = true , [2452] = true , [2453] = true , [3355] = true , [3356] = true , [3357] = true , [3358] = true , [3369] = true , [3820] = true , [3818] = true , [3819] = true , [3821] = true , [4625] = true , [8153] = true , [8831] = true , [8836] = true , [8838] = true , [8839] = true , [8845] = true , [8846] = true , [13463] = true , [13464] = true , [13465] = true , [13466] = true , [13467] = true , [13468] = true , [19726] = true
    },
    ["TBC"] = {
        [181270] = true , [181271] = true , [181275] = true , [181277] = true , [181278] = true , [181279] = true , [181280] = true , [181281] = true
    },
    ["WOTLK"] = {
        [190169] = true , [190170] = true , [190171] = true , [190172] = true , [190173] = true , [190175] = true , [190176] = true , [191303] = true , [189973] = true , [191019] = true
    },
    ["CATA"] = {
        [202747] = true , [202748] = true , [202749] = true , [202750] = true , [202751] = true , [202752] = true
    },
    ["PANDA"] = {
        [89639] = true , [109130] = true , [79010] = true , [79011] = true , [72235] = true , [72237] = true
    },
    ["WOD"] = {
        [109124] = true , [109125] = true , [109126] = true , [109127] = true , [109128] = true , [109129] = true   -- Chameleon Lotus removed from game
    },
    ["LG"] = {
        [124101] = true , [124102] = true , [124103] = true , [124104] = true , [124105] = true , [124106] = true , [128304] = true , [151565] = true
    },
    ["BFA"] = {
        [152505] = true , [152506] = true , [152507] = true , [152508] = true , [152509] = true , [152510] = true , [152511] = true , [168487] = true
    },
    ["SL"] = {
        [187699] = true , [171315] = true , [168583] = true , [168586] = true , [168589] = true , [170554] = true , [169701] = true
    },
    ["DF"] = {
        [191460 ] = true , [191461] = true , [191462] = true , [191464 ] = true , [191465] = true , [191466] = true , [191467 ] = true , [191468] = true , [191469] = true , [191470 ] = true , [191471] = true , [191472] = true
    },
    ["TWW"] = {
        [210796] = true , [210797] = true , [210798] = true , [210799] = true , [210800] = true , [210801] = true , [210802] = true , [210803] = true , [210804] = true , [210805] = true , [210806] = true , [210807] = true , [210808] = true , [210809] = true , [210810] = true , [222538] = true
    }
}

-- Method:          Milling.CombineHerbStacks ( array , bool )
-- What it Does:    Determines which item is being milled, and then keeps the stacks refreshed so milling can continue indefinitely.
-- Purpose:         Quality of life for mass milling thousands.
Milling.CombineHerbStacks = function( scrapSlot , forced )
    if not combiningHerbs or forced then
        combiningHerbs = true;
        scrapSlot = scrapSlot or nil;
        local lowestStack;
        local maxStackSize = 1000
        local itemInfo;
        local itemID;

        local function GetSalveItemDetails()
            local item = ProfessionsFrame.CraftingPage.SchematicForm:GetTransaction().salvageItem;
            if not item then
                return;
            end

            local id = item.debugItemID;
            local itemDetails = item:GetItemLocation();

            if itemDetails then
                local bag , slot = itemDetails.bagID , itemDetails.slotIndex;
                itemInfo = C_Container.GetContainerItemInfo( bag , slot )
                return { bag , slot , itemInfo.stackCount } , id;
            end
        end

        if not scrapSlot and C_TradeSkillUI.IsRecipeRepeating() then
            scrapSlot , itemID = GetSalveItemDetails();
        end

        if scrapSlot then
            -- Now, let's combine all of the smallest herbs to biggest stacks.
            for bag = 0 , NUM_BAG_SLOTS do  -- Loop through all bags (0 is backpack, 1-4 are additional bags)
                for slot = 1, C_Container.GetContainerNumSlots( bag ) do

                    if scrapSlot[1] ~= bag or scrapSlot[2] ~= slot then
                        itemInfo = C_Container.GetContainerItemInfo( bag , slot )

                        if itemInfo and itemInfo.itemID == itemID then

                            if lowestStack and lowestStack[3] > itemInfo.stackCount then
                                lowestStack = { bag , slot , itemInfo.stackCount};
                            elseif not lowestStack then
                                lowestStack = { bag , slot , itemInfo.stackCount};
                            end

                        end
                    end
                end
            end

            if lowestStack then
                C_Container.PickupContainerItem( lowestStack[1] , lowestStack[2] );
                C_Container.PickupContainerItem( scrapSlot[1] , scrapSlot[2] );

                local buttonScript = ProfessionsFrame.CraftingPage.CreateAllButton:GetScript("OnClick");

                if buttonScript then
                    buttonScript();
                end

                if (scrapSlot[3] + lowestStack[3]) < maxStackSize then
                    C_Timer.After ( 1.5 , function()
                        Milling.CombineHerbStacks( scrapSlot , true );  -- Cycle back through to collect ALL the herbs. There needs to be a slight delay between each item move due to Blizz's bag limitations with stacking. not sure why.
                    end);
                    return;
                end
            end
        end
    end
    combiningHerbs = false;
end

-- Method:          Milling.MillListener ( string )
-- What it Does:    Acts as an event listener to control when to trigger the herb stacking action
-- Purpose:         Quality of life helper for mass milling.
Milling.MillListener = function ( id )
    if not combiningHerbs and C_TradeSkillUI.GetRemainingRecasts() < 25 then
        Milling.CombineHerbStacks();
    end
end

local MillingFrame = CreateFrame( "FRAME" , "FCF_MillingListener" );
MillingFrame:RegisterEvent( "TRADE_SKILL_CRAFT_BEGIN" );
MillingFrame:SetScript( "OnEvent" , function( _ , _ , id )

    if MillingSpells[id] then
        Milling.MillListener ( MillingSpells[id] );
    end

end);