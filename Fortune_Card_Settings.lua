-- To hold FCF Settings

local MySettings = {};
FCF.MySettings = MySettings;

-- Method:          MySettings.LoadSettings ( bool )
-- What it Does:    Loads the settings for the addon
-- Purpose:         Control initialization and integrity of addon settings.
MySettings.LoadSettings = function( resetSettings )

    if resetSettings then
        FCF_Save.Setting = {};
    end

    -- Player Controlled Settings
    FCF_Save.Setting = FCF_Save.Setting or {};
    FCF_Save.Setting.autoShow = FCF_Save.Setting.autoShow or true;
    FCF_Save.Setting.autoSellFullBags = FCF_Save.Setting.autoSellFullBags or true;
    FCF_Save.Setting.reportAndReset = FCF_Save.Setting.reportAndReset or { false , 1000 };
    -- Off By Default

    -- UI Settings
    FCF_Save.Setting.CurrentTab = FCF_Save.Setting.CurrentTab or 3;     -- 3 Default = Fated
    FCF_Save.Setting.Position = FCF_Save.Setting.Position or { "CENTER" , "CENTER" , 0 , 0 };

    MySettings.IsValuesReduced();
end

-- Method:          MySettings.IsValuesReduced()
-- What it Does:    Sets the boolean trigger for reduced card values in Retail vs Class
-- Purpose:         In 11.2 Blizzard reduced the value of Omens cards to 10% so this adjusts, assuming in WOD Classic
--                  they keep original valuation
MySettings.IsValuesReduced = function()
    local itemInfo = {GetItemInfo(113354)}; -- Omens 6000g card item
    if #itemInfo == 0 then      -- Trigger twice becomes sometimes after login the server wants 2 queries
        itemInfo = {GetItemInfo(113354)};
    end

    if itemInfo[11] == 6000000 then
        FCF_G.omensIsReduced = true;
        FCF_G.omensCards = { [113354]=600,[113353]=300,[113352]=100,[113351]=10,[113350]=5,[113349]=2,[113348]=1,[113347]=0.5,[113346]=0.5,[113345]=0.1,[113344]=0.1,[113343]=0.05,[113342]=0.05,[113341]=0.01,[113340]=0.0001};
        FCF.UI.coreCards[2].valTable = {
        0.0001,0.01,0.05,0.1,0.5,1,2,5,10,100,300,600
        }
    end

    FCF_G.valuesConfigured = true;
end