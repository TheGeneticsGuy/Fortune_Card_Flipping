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

end
