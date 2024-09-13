-- Author: Aaron Topping (The Genome Whisperer)


SLASH_FLIP1 = '/flip';

-- Saved Variables
FCF_Save = FCF_Save or {};

-- Addon-wide Global
FCF = {};
FCF_G = {};

-- Variables and Tables
FCF_G.fatedTotal = {};
FCF_G.omensTotal = {};
FCF_G.mfcTotal = {};
FCF_G.sessionTotal = {};
FCF_G.sessionTotal.mfc = 0;
FCF_G.sessionTotal.omen = 0;
FCF_G.sessionTotal.fated = 0;
local addonName = "Fortune_Card_Flipping";

--Mysterious Fortune Card (Cata)
FCF_G.mfCards = {[60844]=5000,[60840]=1000,[62603]=50,[62605]=50,[60845]=20,[62604]=5,[60841]=5,[62602]=5,[62606]=5,[60843]=5,[60842]=2,[60839]=1,[62598]=1,[62600]=1,[62599]=1,[62601]=1,[62586]=0.5,[62591]=0.5,[62584]=0.5,[62585]=0.5,[62577]=0.5,[62246]=0.5,[62582]=0.5,[62578]=0.5,[62590]=0.5,[62583]=0.5,[62579]=0.5,[62581]=0.5,[62580]=0.5,[62588]=0.5,[62589]=0.5,[62587]=0.5,[62557]=0.1,[62561]=0.1,[62560]=0.1,[62554]=0.1,[62552]=0.1,[62553]=0.1,[62563]=0.1,[62555]=0.1,[62556]=0.1,[62567]=0.1,[62573]=0.1,[62572]=0.1,[62575]=0.1,[62576]=0.1,[62571]=0.1,[62570]=0.1,[62566]=0.1,[62565]=0.1,[62247]=0.1,[62568]=0.1,[62569]=0.1,[62559]=0.1,[62558]=0.1,[62564]=0.1,[62574]=0.1,[62562]=0.1};

-- Omens cards (Legion)
FCF_G.omensCards = { [113354]=6000,[113353]=3000,[113352]=1000,[113351]=100,[113350]=50,[113349]=20,[113348]=10,[113347]=5,[113346]=5,[113345]=1,[113344]=1,[113343]=0.5,[113342]=0.5,[113341]=0.1,[113340]=0.0001};

-- Fated Cards (Dragonflight)
FCF_G.fatedCards = { [199170]=25000,[199132]=2500,[199131]=500,[199159]=100,[199130]=100,[199160]=50,[199127]=25,[199142]=25,[199138]=25,[199119]=10,[199157]=10,[199152]=10,[199165]=10,[199141]=10,[199114]=7,[199117]=7,[199116]=7,[199133]=7,[199161]=7,[199140]=7,[199151]=7,[199166]=7,[199146]=7,[199118]=7,[199163]=7,[199148]=7,[199139]=7,[199162]=7,[199123]=1,[199136]=1,[199135]=1,[199134]=1,[199147]=1,[199169]=1,[199143]=1,[199155]=1,[199156]=1,[199144]=1,[199126]=1,[199129]=1,[199149]=1,[199168]=1,[199154]=1,[199121]=1,[199145]=1,[199164]=1,[199167]=1,[199124]=1,[199158]=1,[199150]=1,[199125]=1,[199120]=1,[199137]=1,[199153]=1,[198127]="recipe"};

-- Method:          InitializeSaveTables()
-- What it Does:    Initializes the save variables of the addon
-- Purpose:         Ensures tables are established the first time.
FCF.InitializeSaveTables = function()

    -- 5000, 1000, 50, 20, 5, 2, 1, 0.5, 0.1           -- 9 values
    if not FCF_Save.MFC then
        FCF_Save.MFC = {};
    end

    for i = 1 , 9 do
        FCF_G.mfcTotal[i] = 0
        if not FCF_Save.MFC[i] then
            FCF_Save.MFC[i] = 0;
        end
    end

    -- 6000, 3000, 1000, 100, 50, 20, 10, 5, 1, 0.5, 0.1, 0.0001    -- 12 values
    if not FCF_Save.Omen then
        FCF_Save.Omen = {};
    end

    for i = 1 , 12 do
        FCF_G.omensTotal[i] = 0
        if not FCF_Save.Omen[i] then
            FCF_Save.Omen[i] = 0;
        end
    end

    -- 25000, 2500, 500, 100, 50, 25, 10, 7, 1 ,  recipe          -- 10 values
    if not FCF_Save.Fated then
        FCF_Save.Fated = {};
    end

    for i = 1 , 10 do
        FCF_G.fatedTotal[i] = 0
        if not FCF_Save.Fated[i] then
            FCF_Save.Fated[i] = 0;
        end
    end

    FCF.MySettings.LoadSettings();
end

-- Tally the Mysterious Fortune Cards
FCF.CountMFC = function( value )
    FCF_G.sessionTotal.mfc = FCF_G.sessionTotal.mfc + 1;
    local valTable = { [5000]=1, [1000]=2, [50]=3, [20]=4, [5]=5, [2]=6, [1]=7, [0.5]=8, [0.1]=9 };
    FCF_Save.MFC[valTable[value]] = FCF_Save.MFC[valTable[value]] + 1;
    FCF_G.mfcTotal[valTable[value]] = FCF_G.mfcTotal[valTable[value]] + 1;

    if FCF.S().autoSellFullBags then
        FCF.Vendor.AutoSellIfBagsFull();
    end

    if FCF_Save.Setting.reportAndReset[1] and FCF_Save.Setting.reportAndReset[2] == FCF_G.sessionTotal.mfc then
        FCF.Report.ReportMFC( FCF_G.mfcTotal );

        -- Reset Table
        for i = 1 , #FCF_G.mfcTotal do
            FCF_G.mfcTotal[i] = 0;
        end
        FCF_G.sessionTotal.fmc = 0;

    end
end

-- Tally the Omens Cards
FCF.CountOmens = function( value )
    FCF_G.sessionTotal.omen = FCF_G.sessionTotal.omen + 1;
    local valTable = { [6000]=1, [3000]=2, [1000]=3, [100]=4, [50]=5, [20]=6, [10]=7, [5]=8, [1]=9, [0.5]=10, [0.1]=11, [0.0001]=12 };
    FCF_Save.Omen[valTable[value]] = FCF_Save.Omen[valTable[value]] + 1;
    FCF_G.omensTotal[valTable[value]] = FCF_G.omensTotal[valTable[value]] + 1;

    if FCF.S().autoSellFullBags then
        FCF.Vendor.AutoSellIfBagsFull();
    end
end

-- Tally the Fated Cards
FCF.CountFated = function( value )
    FCF_G.sessionTotal.fated = FCF_G.sessionTotal.fated + 1;
    local valTable = { [25000]=1, [2500]=2, [500]=3, [100]=4, [50]=5, [25]=6, [10]=7, [7]=8, [1]=9, ["recipe"]=10 };
    FCF_Save.Fated[valTable[value]] = FCF_Save.Fated[valTable[value]] + 1;
    FCF_G.fatedTotal[valTable[value]] = FCF_G.fatedTotal[valTable[value]] + 1;

    if FCF.S().autoSellFullBags then
        FCF.Vendor.AutoSellIfBagsFull();
    end

    if FCF_Save.Setting.reportAndReset[1] and FCF_Save.Setting.reportAndReset[2] == FCF_G.sessionTotal.fated then
        FCF.Report.ReportFated( FCF_G.fatedTotal );

        -- Reset Table
        for i = 1 , #FCF_G.fatedTotal do
            FCF_G.fatedTotal[i] = 0;
        end
        FCF_G.sessionTotal.fated = 0;

    end

end

-- Method on detection of a looting event.
FCF.CardCounting = function ( _ , _ , msg )
    -- Iterating through all of the arrays. Breaks function(return) on discovery.
    -- Fated Cards
    local id = tonumber ( string.match ( msg ,"|Hitem:(%d+):" ) );

    if FCF_G.fatedCards[id] then
        FCF.CountFated( FCF_G.fatedCards[id] );
    elseif FCF_G.omensCards[id] then
        FCF.CountOmens( FCF_G.omensCards[id] );
    elseif FCF_G.mfCards[id] then
        FCF.CountMFC( FCF_G.mfCards[id] );
    end

end

------------------------
---- INITIALIZATION ----
------------------------

-- Method:          FCF.InitializeAddon()
-- What it Does:    Initializes the variables, ensures save variablea are formatted and session tables
-- Purpose:         Proper storage data set before beginning tracking card looting.
FCF.InitializeAddon = function()
    FCF.InitializeSaveTables();

    -- Addon event tracking "frame"
    local flipEvent = CreateFrame("Frame");

    flipEvent:RegisterEvent("CHAT_MSG_LOOT");
    flipEvent:SetScript( "OnEvent" , FCF.CardCounting );
end

-- Method:          FCF.ActivateAddon ( ... , string , string )
-- What it Does:"   Controls load order of addon to ensure it doesn't initialize until player has fully logged into the world
-- Purpose:         Some things don't needto load until player is entering the world.
FCF.ActivateAddon = function ( _ , event , addon )
    if event == "ADDON_LOADED" then
    -- initiate addon once all variable are loaded.
        if addon == addonName then
            FCF.Initialization:RegisterEvent ( "PLAYER_ENTERING_WORLD" ); -- Ensures this check does not occur until after Addon is fully loaded. By registering, it acts recursively throug hthis method
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        FCF.InitializeAddon();
        FCF.Initialization:UnregisterAllEvents();
        FCF.Initialization = nil;
    end
end

FCF.Initialization = CreateFrame ( "Frame" );
FCF.Initialization:RegisterEvent ( "ADDON_LOADED" );
FCF.Initialization:SetScript ( "OnEvent" , FCF.ActivateAddon );

-------------------------------
-------- DATA ACCESS ----------
-------------------------------

-- Method:          FCF.S()
-- What it Does:    Call the save variables
-- Purpose:         Easily call the save table.
FCF.S = function()
    return FCF_Save.Setting;
end

-- Resets Card values
function FlipReset()
    -- MFCs
    FCF_G.sessionTotal.mfc = 0;
    FCF_G.sessionTotal.omen = 0;
    FCF_G.sessionTotal.fated = 0;

    for i = 1 , #FCF_G.fatedTotal do
        FCF_G.fatedTotal[i] = 0;
    end

    for i = 1 , #FCF_G.omensTotal do
        FCF_G.omensTotal[i] = 0;
    end

    for i = 1 , #FCF_G.mfcTotal do
        FCF_G.mfcTotal[i] = 0;
    end

end

-- resets historical data
function FlipResetHistorical()
    for i = 1 , #FCF_Save.MFC do
        FCF_Save.MFC[i] = 0;
    end

    for i = 1 , #FCF_Save.Omen do
        FCF_Save.Omen[i] = 0;
    end

    for i = 1 , #FCF_Save.Fated do
        FCF_Save.Fated[i] = 0;
    end
end

SlashCmdList["FLIP"] = function(input)
    if input == nil or input:trim() == "" then
        FCF.Report.ReportMFC( FCF_G.mfcTotal );
        FCF.Report.ReportFated( FCF_G.fatedTotal );

           -- Print Complete Historical data
    elseif input == "history" then
        FCF.Report.ReportMFC();
        FCF.Report.ReportFated();

    --Reset
    elseif input == "reset" then
        print("Card Flip Data Has Been RESET for this session.");
        FlipReset();

    elseif input == "resetAll" then
        print("All Card Flip Data, including SAVED, has been RESET.");
        FlipReset();
        FlipResetHistorical();

    -- All commands!
    elseif input == "help" then
        local result = "\n------------------------------------------\n---          CARD FLIPPING          ---\n----          INFORMATION          ----\n------------------------------------------";
            result = result .. "\nTo Check Current Progress:         /flip";
            result = result .. "\nFor ALL saved counts:                  /flip history";
            result = result .. "\nReset Current Session to Zero:   /flip reset";
            result = result .. "\nReset Saved Data to Zero:          /flip resetAll";
            print(result);
    -- Input is bad
    else
        print("ERROR! Input not recognized.");
        print("Please type /flip help for info.");
    end
end
