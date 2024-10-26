local Vendor = {};
FCF.Vendor = Vendor;
local currently_counting = false

-- Right now, any card 1000g+
local excludedIDs = { [60844] = true , [60840] = true , [113354] = true ,[113353] = true , [113352] = true , [199170] = true , [199132] = true , [194829] = true  } -- , [198127] = true (coookie recipe)

-- Method:          Vendor.AutoSellCards( int , int , int , float , float , float)
-- What it Does:    Auto sells the chance fortune cards from any expansion to vendor
-- Purpose:         Easier than having to sell individually.
Vendor.AutoSellCards = function( count , previousMoney , isLoop )

    if not currently_counting or isLoop then
        currently_counting = true

        count = count or 0;
        previousMoney = previousMoney or GetMoney();

        local id = 0;
        local limit = 10;   -- Vendor has internal limit of 10 max a loop
        local limitCount = 0;
        local delay = 1;

        for i = 0 , NUM_BAG_SLOTS do
            for j = 1 , C_Container.GetContainerNumSlots(i) do
                id = C_Container.GetContainerItemID( i, j );

                if id then

                    if not excludedIDs[id] and ( FCF_G.fatedCards[id] or FCF_G.omensCards[id] or FCF_G.mfCards[id] ) then
                        limitCount = limitCount + 1;
                        count = count + 1;
                        C_Container.UseContainerItem(i, j)

                        if limitCount == 10 then
                            C_Timer.After ( delay , function()
                                Vendor.AutoSellCards( count , previousMoney , true )
                            end);
                            return;
                        end

                    end
                end
            end
        end
        if count then
            C_Timer.After ( 1 , function()
                local difference = Vendor.GetGoldDifference ( previousMoney );
                if difference ~= "" then
                    print(string.format( "Total Card Value Sold: (%s)" , Vendor.GetGoldDifference ( previousMoney ) ) );
                end
            end);
        end
        currently_counting = false
    end
end

-- Method:          Vendor.MerchantSell ( ... )
-- What it Does:    Listens for when the vendor opens, and when vendor opens it sells all the Fortune Cards of any type
-- Purpose:         Properly Sell cards
Vendor.MerchantSell = function ( _ , event)

	if event == "MERCHANT_SHOW" and FCF.S().autoSellFullBags then
		Vendor.AutoSellCards();
	end
end

-- Method:          Vendor.AutoSellIfBagsFull()
-- What it Does:    Triggers the auto vendoring of all items if the bags are full
-- Purpose:         Control the sale of cards
Vendor.AutoSellIfBagsFull = function()

    if MerchantFrame:IsShown() then
        local count = 0;
        for i = 1 , NUM_BAG_SLOTS do
            count = count + C_Container.GetContainerNumFreeSlots(i);
        end

        if count < 3 and FCF.S().autoSellFullBags then -- Trigger to sell at 1 as when it's zero the next one will go to mailbox
            Vendor.AutoSellCards();
        end
    end
end

-- Method:          Vendor.GetGoldDifference ( int )
-- What it Does:    Returns the vendor difference of starting money to what you have now
-- Purpose:         So the amount sold can be tallied
Vendor.GetGoldDifference = function ( previousMoney )
    local difference = GetMoney() - previousMoney;

    local gold = floor(difference / (100 * 100))  -- Convert from copper to gold
    local silver = floor((difference / 100) % 100)  -- Convert from copper to silver
    local copper = difference % 100
    local final = "";

    if gold > 0 then
        final = gold.."g";
    end
    if silver > 0 then
        final = final .. silver .. "s";
    end
    if copper > 0 then
        final = final .. copper .. "c";
    end

    return final;
end

local vendorFrame = CreateFrame( "FRAME" , "FCF_VendorListener" );
vendorFrame:RegisterEvent( "MERCHANT_SHOW" );
vendorFrame:SetScript( "OnEvent" , Vendor.MerchantSell);