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

    FCF_Save.Setting = FCF_Save.Setting or {};
    FCF_Save.Setting.autoSellFullBags = FCF_Save.Setting.autoSellFullBags or true;
    FCF_Save.Setting.reportAndReset = FCF_Save.Setting.reportAndReset or { true , 1000 };
    FCF_Save.Setting.stackHerbsDuringMill = FCF_Save.Setting.stackHerbsDuringMill or true;

end
