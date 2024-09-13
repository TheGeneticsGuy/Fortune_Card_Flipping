-- For reporting the results

local Report = {};
FCF.Report = Report;

-- Method:          Report.ReportMFC ( table )
-- What it Does:    Builds the card report for MFCs
-- Purpose:         Clean reporting
Report.ReportMFC = function( cards )
    local tagLine = "";
    local totalValue = 0;

    if not cards then
        tagLine = "HISTORICAL"
        cards = FCF_Save.MFC;
        totalValue = Report.TotalMFCValueHistorical();
    else
        tagLine = "CURRENT SESSION";
        totalValue = Report.TotalMFCValue();
    end

    print("\n");
    print("MYSTERIOUS FORTUNE CARD RESULTS - " .. tagLine);
    print(".1g:         " .. cards[9]);
    print(".5g:         " .. cards[8]);
    print("1g:          " .. cards[7]);
    print("2g:          " .. cards[6])
    print("5g:          " .. cards[5]);
    print("20g:        " .. cards[4]);
    print("50g:        " .. cards[3]);
    print("1000g:    " .. cards[2]);
    print("5000g:    " .. cards[1]);
    print("TOTAL:   " .. Report.GetTotalCards(cards) .. " Cards" );
    print("TOTAL VALUE: " .. totalValue .. "g")
    print("\n")

end

-- Method:          Report.ReportFated ( table )
-- What it Does:    Builds the card report for MFCs
-- Purpose:         Clean reporting
Report.ReportFated = function( cards )
    local tagLine = "";
    local totalValue = 0;

    if not cards then
        tagLine = "HISTORICAL"
        cards = FCF_Save.Fated;
        totalValue = Report.TotalFatedValueHistorical();
    else
        tagLine = "CURRENT SESSION";
        totalValue = Report.TotalFatedValue();
    end

    print("\n");
    print("FATED FORTUNE CARD RESULTS - " .. tagLine);
    print("Recipe:    " .. cards[10] .. " (Value not Included)");
    print("1g:            " .. cards[9]);
    print("7g:            " .. cards[8]);
    print("10g:          " .. cards[7]);
    print("25g:          " .. cards[6])
    print("50g:          " .. cards[5]);
    print("100g:        " .. cards[4]);
    print("500g:        " .. cards[3]);
    print("2500g:      " .. cards[2]);
    print("25000g:    " .. cards[1]);
    print("TOTAL:    " .. Report.GetTotalCards(cards) .. " Cards" );
    print( string.format ("TOTAL VALUE: %.2fg" , totalValue ) )
    print("\n")

end

-- Method:          Report.GetTotalCards ( array )
-- What it Does:    Counts all the numbers in the array
-- Purpose:         So you can easily count total cards
Report.GetTotalCards = function ( cards )
    local count = 0;
    for i = 1 , #cards do
        count = count + cards[i];
    end
    return count;
end

Report.ReportOmens = function( cards )
    cards = cards or FCF_Save.Omen;
end

-- Adds up all HISTORICAL MFC gold value.
Report.TotalMFCValueHistorical = function()
    local result = (FCF_Save.MFC[9]*0.1)+(FCF_Save.MFC[8]*0.5)+(FCF_Save.MFC[7]*1)+(FCF_Save.MFC[6]*2)+(FCF_Save.MFC[5]*5)+(FCF_Save.MFC[4]*20)+(FCF_Save.MFC[3]*50)+(FCF_Save.MFC[2]*1000)+(FCF_Save.MFC[1]*5000);
    return result;
end

-- Adds up historal value of Blood Cards
Report.TotalOmensValueHistorical = function()
    local result = (FCF_Save.Omen[12]*0.001)+(FCF_Save.Omen[11]*0.1)+(FCF_Save.Omen[10]*0.5)+(FCF_Save.Omen[9]*1)+(FCF_Save.Omen[8]*5)+(FCF_Save.Omen[7]*10)+(FCF_Save.Omen[6]*20)+(FCF_Save.Omen[5]*50)+(FCF_Save.Omen[4]*100)+(FCF_Save.Omen[3]*1000)+(FCF_Save.Omen[2]*3000)+(FCF_Save.Omen[1]*6000);
    return result;
end

-- Adds up historal value of Blood Cards
Report.TotalFatedValueHistorical = function()
    local result = (FCF_Save.Fated[1]*25000)+(FCF_Save.Fated[2]*2500)+(FCF_Save.Fated[3]*500)+(FCF_Save.Fated[4]*100)+(FCF_Save.Fated[5]*50)+(FCF_Save.Fated[6]*25)+(FCF_Save.Fated[7]*10)+(FCF_Save.Fated[8]*7)+(FCF_Save.Fated[9]*1);
    return result;
end

--Adds up gold value of this session
Report.TotalMFCValue = function()
    local result = (FCF_G.mfcTotal[9]*0.1)+(FCF_G.mfcTotal[8]*0.5)+(FCF_G.mfcTotal[7]*1)+(FCF_G.mfcTotal[6]*2)+(FCF_G.mfcTotal[5]*5)+(FCF_G.mfcTotal[4]*20)+(FCF_G.mfcTotal[3]*50)+(FCF_G.mfcTotal[2]*1000)+(FCF_G.mfcTotal[1]*5000);
    return result
end

-- Adds up gold value of all Blood Cards
Report.TotalOmensValue = function()
    local result = (FCF_G.omensTotal[12]*0.001)+(FCF_G.omensTotal[11]*0.1)+(FCF_G.omensTotal[10]*0.5)+(FCF_G.omensTotal[9]*1)+(FCF_G.omensTotal[8]*5)+(FCF_G.omensTotal[7]*10)+(FCF_G.omensTotal[6]*20)+(FCF_G.omensTotal[5]*50)+(FCF_G.omensTotal[4]*100)+(FCF_G.omensTotal[3]*1000)+(FCF_G.omensTotal[2]*3000)+(FCF_G.omensTotal[1]*6000);
    return result;
end

Report.TotalFatedValue = function()
    local result = (FCF_G.fatedTotal[1]*25000)+(FCF_G.fatedTotal[2]*2500)+(FCF_G.fatedTotal[3]*500)+(FCF_G.fatedTotal[4]*100)+(FCF_G.fatedTotal[5]*50)+(FCF_G.fatedTotal[6]*25)+(FCF_G.fatedTotal[7]*10)+(FCF_G.fatedTotal[8]*7)+(FCF_G.fatedTotal[9]*1);
    return result;
end