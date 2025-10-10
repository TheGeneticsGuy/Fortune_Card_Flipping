-- For reporting the results

local Report = {};
FCF.Report = Report;

-- Method:          Report.ReportMFC ( table )
-- What it Does:    Builds the card report for MFCs
-- Purpose:         Clean reporting
Report.ReportMFC = function( cards )
    local totalValue = Report.TotalMFCValue( cards);

    print("\n");
    print("MYSTERIOUS FORTUNE CARD RESULTS - CURRENT SESSION" );
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
    print("TOTAL VALUE: " ..  string.format ( "%.2fg" , totalValue ))
    print("\n")

end

-- Method:          Report.ReportOmens ( table )
-- What it Does:    Builds the card report for Omens Cards
-- Purpose:         Clean reporting
Report.ReportOmens = function( cards )
    local totalValue = Report.TotalOmensValue( cards);

    print("\n");
    print("MYSTERIOUS FORTUNE CARD RESULTS - CURRENT SESSION" );
    print("0.0001g: " .. cards[12]);
    print("0.1g:      " .. cards[11]);
    print("0.5g:      " .. cards[10]);
    print("1g:          " .. cards[9]);
    print("5g:          " .. cards[8]);
    print("10g:        " .. cards[7])
    print("20g:        " .. cards[6]);
    print("50g:        " .. cards[5]);
    print("100g:      " .. cards[4]);
    print("1000g:    " .. cards[3]);
    print("3000g:    " .. cards[2]);
    print("6000g:    " .. cards[1]);
    print("TOTAL:   " .. Report.GetTotalCards(cards) .. " Cards" );
    print("TOTAL VALUE: " ..  string.format ( "%.2fg" , totalValue ))
    print("\n")
end

-- Method:          Report.ReportFated ( table )
-- What it Does:    Builds the card report for Fated Cards
-- Purpose:         Clean reporting
Report.ReportFated = function( cards )
    local totalValue = Report.TotalFatedValue( cards);

    print("\n");
    print("FATED FORTUNE CARD RESULTS - CURRENT SESSION" );
    print("0.125g:  " .. cards[10] .. " (Recipe)");
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
    print("TOTAL VALUE: " ..  string.format ( "%.2fg" , totalValue ) )
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

--Adds up gold value of this session
Report.TotalMFCValue = function( cards )
    local result = (cards[9]*0.1)+(cards[8]*0.5)+(cards[7]*1)+(cards[6]*2)+(cards[5]*5)+(cards[4]*20)+(cards[3]*50)+(cards[2]*1000)+(cards[1]*5000);
    return result
end

-- Adds up gold value of all Blood Cards
Report.TotalOmensValue = function( cards )
    local result = (cards[12]*0.001)+(cards[11]*0.1)+(cards[10]*0.5)+(cards[9]*1)+(cards[8]*5)+(cards[7]*10)+(cards[6]*20)+(cards[5]*50)+(cards[4]*100)+(cards[3]*1000)+(cards[2]*3000)+(cards[1]*6000);
    return result;
end

Report.TotalFatedValue = function( cards )
    local result = (cards[1]*25000)+(cards[2]*2500)+(cards[3]*500)+(cards[4]*100)+(cards[5]*50)+(cards[6]*25)+(cards[7]*10)+(cards[8]*7)+(cards[9]*1)+(cards[10]*0.125);
    return result;
end