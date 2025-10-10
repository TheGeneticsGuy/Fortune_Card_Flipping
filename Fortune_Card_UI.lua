local UI = {};
FCF.UI = UI;

local coreCards = {
    [1] = {
        ["id"] = 60838,
        ["texture"] = 134493,
        ["name"] = "Mysterious Fortune Card",
        ["valTable"] = {
            0.1,0.5,1,2,5,20,50,1000,5000
        }
    },
    [2] = {
        ["id"] = 113355,
        ["texture"] = 134498,
        ["name"] = "Card of Omens",
        ["valTable"] = {
            0.0001,0.1,0.5,1,5,10,20,50,100,1000,3000,6000
        }
    },
    [3] = {
        ["id"] = 194829,
        ["texture"] = 4638489,
        ["name"] = "Fated Fortune Card",
        ["valTable"] = {
            0.125,1,7,10,25,50,100,500,2500,25000     -- item ID and Texture included for fortune cookie recipe
        }
    }
}

local biggestValuesTable = 15; -- Omens has 12 values. Plus 3 for Total Cards and Total Value and Avg
local spreadSheetLink = "https://tinyurl.com/fortunecardflip";

-- Method:          UI.BuildMainWindow( bool )
-- What it Does:    Builds the core count frame for addon
-- Purpose:         To display the player logged flip history data.
UI.BuildMainWindow = function( reprocessText )
    if not UI.FCF_Count_Frame then
        reprocessText = true;        -- First time should always reprocess

        UI.FCF_Count_Frame = CreateFrame ( "Frame" , "FCF_Count_Frame" , UIParent , "TranslucentFrameTemplate" );
        UI.FCF_Count_Frame.CloseButton = CreateFrame ("Button" , nil ,  UI.FCF_Count_Frame , "UIPanelCloseButton" );

        -- Frame Details
        UI.FCF_Count_Frame:SetPoint( FCF_Save.Setting.Position[1] , UIParent , FCF_Save.Setting.Position[2] , FCF_Save.Setting.Position[3] , FCF_Save.Setting.Position[4] );
        UI.FCF_Count_Frame:SetSize( 620 , 510 );
        UI.FCF_Count_Frame:EnableMouse ( true );
        UI.FCF_Count_Frame:SetToplevel ( true );
        UI.FCF_Count_Frame:SetMovable ( true );
        UI.FCF_Count_Frame:SetUserPlaced ( true );
        UI.FCF_Count_Frame:RegisterForDrag ( "LeftButton" );
        UI.FCF_Count_Frame:SetFrameStrata("HIGH");

        -- Variables
        UI.FCF_Count_Frame.tabIndex = FCF_Save.Setting.CurrentTab

        -- Close Button
        UI.FCF_Count_Frame.CloseButton:SetPoint( "TOPRIGHT" , UI.FCF_Count_Frame , "TOPRIGHT" , -4 , -4 );
        UI.FCF_Count_Frame.CloseButton:SetSize ( 26 , 26 );

        -- Frame Script Logic
        UI.FCF_Count_Frame:SetScript ( "OnDragStart" , UI.FCF_Count_Frame.StartMoving );
        UI.FCF_Count_Frame:SetScript ( "OnDragStop" , function()
            UI.FCF_Count_Frame:StopMovingOrSizing();
            UI.SaveCorePosition();
        end);
        UI.FCF_Count_Frame:SetScript ( "OnShow" , function()
            if UI.FCF_Count_Frame.tabIndex == 3 then
                UI.FCF_Count_Frame.FCF_FatedTab:Click();

            elseif UI.FCF_Count_Frame.tabIndex == 2 then
                UI.FCF_Count_Frame.FCF_OmensTab:Click();

            elseif UI.FCF_Count_Frame.tabIndex == 1 then
                UI.FCF_Count_Frame.FCF_MFCTab:Click();
            end
        end)

        -- Title
        UI.FCF_Count_Frame.TitleText = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontNormal" );
        UI.FCF_Count_Frame.TitleText:SetWidth ( UI.FCF_Count_Frame:GetWidth() - 10 );
        UI.FCF_Count_Frame.TitleText:SetSpacing ( 1 );
        UI.FCF_Count_Frame.TitleText:SetPoint ( "TOP" , UI.FCF_Count_Frame , "TOP" , 0 , -25 );

        UI.FCF_Count_Frame.FCF_FatedTab = CreateFrame ( "Button" , "FCF_FatedTab" , UI.FCF_Count_Frame , "MinimalTabTemplate" );
        UI.FCF_Count_Frame.FCF_FatedTabText = UI.FCF_Count_Frame.FCF_FatedTab:CreateFontString ( nil , "OVERLAY" , "GameFontNormal" );
        UI.FCF_Count_Frame.FCF_OmensTab = CreateFrame ( "Button" , "FCF_OmensTab" , UI.FCF_Count_Frame , "MinimalTabTemplate" );
        UI.FCF_Count_Frame.FCF_OmensTabText = UI.FCF_Count_Frame.FCF_OmensTab:CreateFontString ( nil , "OVERLAY" , "GameFontNormal" );
        UI.FCF_Count_Frame.FCF_MFCTab = CreateFrame ( "Button" , "FCF_MFCTab" , UI.FCF_Count_Frame , "MinimalTabTemplate" );
        UI.FCF_Count_Frame.FCF_MFCTabText = UI.FCF_Count_Frame.FCF_MFCTab:CreateFontString ( nil , "OVERLAY" , "GameFontNormal" );

        -- Omens card first so it is centered
        UI.FCF_Count_Frame.FCF_OmensTab:SetPoint ( "TOP" , UI.FCF_Count_Frame.TitleText , "BOTTOM" , 0 , -25 );
        UI.FCF_Count_Frame.FCF_OmensTab:SetSize ( 185 , 25 );
        UI.FCF_Count_Frame.FCF_OmensTab:SetHighlightTexture ( "Interface\\Buttons\\ButtonHilight-Square" );
        UI.FCF_Count_Frame.FCF_OmensTabText:SetPoint ( "CENTER" , UI.FCF_Count_Frame.FCF_OmensTab , 0 , -3 );

        if UI.FCF_Count_Frame.tabIndex == 2 then
            UI.FCF_Count_Frame.FCF_OmensTab:LockHighlight();
        end

        UI.FCF_Count_Frame.FCF_OmensTab:SetScript ( "OnClick" , function ( self , button )
            if button == "LeftButton" then
                self:LockHighlight();
                UI.FCF_Count_Frame.FCF_MFCTab:UnlockHighlight();
                UI.FCF_Count_Frame.FCF_FatedTab:UnlockHighlight();
                UI.FCF_Count_Frame.tabIndex = 2;
                UI.SetCardValues( UI.FCF_Count_Frame.tabIndex );
                UI.RefreshCount("omens");
            end
        end);

        UI.FCF_Count_Frame.FCF_FatedTab:SetPoint ( "RIGHT" , UI.FCF_Count_Frame.FCF_OmensTab , "LEFT" , -4 , 0 );
        UI.FCF_Count_Frame.FCF_FatedTab:SetSize ( 185 , 25 );
        UI.FCF_Count_Frame.FCF_FatedTab:SetHighlightTexture ( "Interface\\Buttons\\ButtonHilight-Square" );
        UI.FCF_Count_Frame.FCF_FatedTabText:SetPoint ( "CENTER" , UI.FCF_Count_Frame.FCF_FatedTab , 0 , -3 );

        if UI.FCF_Count_Frame.tabIndex == 3 then
            UI.FCF_Count_Frame.FCF_FatedTab:LockHighlight();
        end

        UI.FCF_Count_Frame.FCF_FatedTab:SetScript ( "OnClick" , function ( self , button )
            if button == "LeftButton" then
                self:LockHighlight();
                UI.FCF_Count_Frame.FCF_OmensTab:UnlockHighlight();
                UI.FCF_Count_Frame.FCF_MFCTab:UnlockHighlight();
                UI.FCF_Count_Frame.tabIndex = 3;
                UI.SetCardValues( UI.FCF_Count_Frame.tabIndex );
                UI.RefreshCount("fated");
            end
        end);

        UI.FCF_Count_Frame.FCF_MFCTab:SetPoint ( "LEFT" , UI.FCF_Count_Frame.FCF_OmensTab , "RIGHT" , 4 , 0 );
        UI.FCF_Count_Frame.FCF_MFCTab:SetSize ( 185 , 25 );
        UI.FCF_Count_Frame.FCF_MFCTab:SetHighlightTexture ( "Interface\\Buttons\\ButtonHilight-Square" );
        UI.FCF_Count_Frame.FCF_MFCTabText:SetPoint ( "CENTER" , UI.FCF_Count_Frame.FCF_MFCTab , 0 , -3 );

        if UI.FCF_Count_Frame.tabIndex == 1 then
            UI.FCF_Count_Frame.FCF_MFCTab:LockHighlight();
        end

        UI.FCF_Count_Frame.FCF_MFCTab:SetScript ( "OnClick" , function ( self , button )
            if button == "LeftButton" then
                self:LockHighlight();
                UI.FCF_Count_Frame.FCF_OmensTab:UnlockHighlight();
                UI.FCF_Count_Frame.FCF_FatedTab:UnlockHighlight();
                UI.FCF_Count_Frame.tabIndex = 1;
                UI.SetCardValues( UI.FCF_Count_Frame.tabIndex );
                UI.RefreshCount("mfc");
            end
        end);

        -- let's build the icon texture for card title
        UI.FCF_Count_Frame.CardTypeTexture = UI.FCF_Count_Frame:CreateTexture(nil,"ARTWORK");
        UI.FCF_Count_Frame.CardTypeTexture:SetSize ( 30 , 30 );
        UI.FCF_Count_Frame.CardTypeTexture:SetPoint ( "TOPLEFT" , UI.FCF_Count_Frame.FCF_FatedTab , "BOTTOMLEFT" , 0 , -10 );

        -- Now, the card type after the texture
        UI.FCF_Count_Frame.CartTypeText = UI.FCF_Count_Frame:CreateFontString ( nil , "OVERLAY" , "GameFontNormal" );
        UI.FCF_Count_Frame.CartTypeText:SetPoint ( "LEFT" , UI.FCF_Count_Frame.CardTypeTexture , "RIGHT" , 5 , 0 );

        -- Grid headers of data
        UI.FCF_Count_Frame.ValueHeaderText = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.ValueHeaderText:SetPoint ( "TopLeft" , UI.FCF_Count_Frame.CardTypeTexture , "BOTTOMLEFT" , 0 , -20 );
        UI.FCF_Count_Frame.ValueHeaderText:SetJustifyH("LEFT");
        UI.FCF_Count_Frame.ValueHeaderText:SetWidth(80);
        UI.FCF_Count_Frame.ValueHeaderText:SetWordWrap(false);

        local columnWidth = math.floor ( ( UI.FCF_Count_Frame:GetWidth() - UI.FCF_Count_Frame.ValueHeaderText:GetWidth() - 50 ) / 4 );    -- 50 is just for extra spacing

        UI.FCF_Count_Frame.CurrentSessionHeaderText = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.CurrentSessionHeaderText:SetPoint ( "LEFT" , UI.FCF_Count_Frame.ValueHeaderText , "RIGHT" , 1 , 0 );
        UI.FCF_Count_Frame.CurrentSessionHeaderText:SetJustifyH("CENTER");
        UI.FCF_Count_Frame.CurrentSessionHeaderText:SetWidth(columnWidth);
        UI.FCF_Count_Frame.CurrentSessionHeaderText:SetWordWrap(false);

        UI.FCF_Count_Frame.CurrentSessionHeaderTextUL = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.CurrentSessionHeaderTextUL:SetPoint ( "TOP" , UI.FCF_Count_Frame.CurrentSessionHeaderText , "BOTTOM" , 0 , 2 );
        UI.FCF_Count_Frame.CurrentSessionHeaderTextUL:SetText("_______________");

        UI.FCF_Count_Frame.HistoricalHeaderText = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.HistoricalHeaderText:SetPoint ( "LEFT" , UI.FCF_Count_Frame.CurrentSessionHeaderText , "RIGHT" , 1 , 0 );
        UI.FCF_Count_Frame.HistoricalHeaderText:SetJustifyH("CENTER");
        UI.FCF_Count_Frame.HistoricalHeaderText:SetWidth(columnWidth);
        UI.FCF_Count_Frame.HistoricalHeaderText:SetWordWrap(false);

        UI.FCF_Count_Frame.HistoricalHeaderTextUL = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.HistoricalHeaderTextUL:SetPoint ( "TOP" , UI.FCF_Count_Frame.HistoricalHeaderText , "BOTTOM" , 0 , 2 );
        UI.FCF_Count_Frame.HistoricalHeaderTextUL:SetText("_____________________");

        UI.FCF_Count_Frame.GlobalHeaderText = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.GlobalHeaderText:SetPoint ( "LEFT" , UI.FCF_Count_Frame.HistoricalHeaderText , "RIGHT" , 1 , 0 );
        UI.FCF_Count_Frame.GlobalHeaderText:SetJustifyH("CENTER");
        UI.FCF_Count_Frame.GlobalHeaderText:SetWidth(columnWidth);
        UI.FCF_Count_Frame.GlobalHeaderText:SetWordWrap(false);

        UI.FCF_Count_Frame.GlobalHeaderTextUL = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.GlobalHeaderTextUL:SetPoint ( "TOP" , UI.FCF_Count_Frame.GlobalHeaderText , "BOTTOM" , 0 , 2 );
        UI.FCF_Count_Frame.GlobalHeaderTextUL:SetText("_______________");

        UI.FCF_Count_Frame.ProbHeaderText = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.ProbHeaderText:SetPoint ( "LEFT" , UI.FCF_Count_Frame.GlobalHeaderText , "RIGHT" , 1 , 0 );
        UI.FCF_Count_Frame.ProbHeaderText:SetJustifyH("CENTER");
        UI.FCF_Count_Frame.ProbHeaderText:SetWidth(columnWidth);
        UI.FCF_Count_Frame.ProbHeaderText:SetWordWrap(false);

        UI.FCF_Count_Frame.ProbHeaderTextUL = UI.FCF_Count_Frame:CreateFontString( nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.ProbHeaderTextUL:SetPoint ( "TOP" , UI.FCF_Count_Frame.ProbHeaderText , "BOTTOM" , 0 , 2 );
        UI.FCF_Count_Frame.ProbHeaderTextUL:SetText("______________________");

        -- Global Info
        UI.FCF_Count_Frame.FCF_GlobalInfoButton = CreateFrame ( "Button" , "FCF_GlobalInfoButton" , UI.FCF_Count_Frame , "GameMenuButtonTemplate" );
        UI.FCF_Count_Frame.FCF_GlobalInfoButton:SetSize ( 24 , 24);
        UI.FCF_Count_Frame.FCF_GlobalInfoButton:SetPoint("BOTTOMRIGHT" , UI.FCF_Count_Frame.GlobalHeaderText , "TOPRIGHT" , -20 , 5 );
        UI.FCF_Count_Frame.FCF_GlobalInfoButton:SetText( "?" );

        UI.FCF_Count_Frame.FCF_GlobalInfoButton:SetScript ( "OnEnter" , function ( self )
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR" );
            GameTooltip:AddLine("Global data has been colleted by the author.To view the\nfull spreadsheet, please type the following in chat:\n/flip ss" , 1 , 0 , 0 );
            GameTooltip:Show()
        end)

        UI.FCF_Count_Frame.FCF_GlobalInfoButton:SetScript("OnLeave" , function()
            GameTooltip:Hide();
        end)

        -- Probability Info
        UI.FCF_Count_Frame.FCF_ProbInfoButton = CreateFrame ( "Button" , "FCF_ProbInfoButton" , UI.FCF_Count_Frame , "GameMenuButtonTemplate" );
        UI.FCF_Count_Frame.FCF_ProbInfoButton:SetSize ( 24 , 24);
        UI.FCF_Count_Frame.FCF_ProbInfoButton:SetPoint("BOTTOMRIGHT" , UI.FCF_Count_Frame.ProbHeaderText , "TOPRIGHT" , -5 , 5 );
        UI.FCF_Count_Frame.FCF_ProbInfoButton:SetText( "?" );

        UI.FCF_Count_Frame.FCF_ProbInfoButton:SetScript ( "OnEnter" , function ( self )
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR" );
            GameTooltip:AddLine("Probabilities are based on global data provided by the author,\ncombined with your own historical data." ,  1 , 0 , 0 );
            GameTooltip:Show()
        end)

        UI.FCF_Count_Frame.FCF_ProbInfoButton:SetScript("OnLeave" , function()
            GameTooltip:Hide();
        end)

        -- Add checkboxes
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox = CreateFrame ( "CheckButton" , "FCF_AutoShowCheckBox" , UI.FCF_Count_Frame , "InterfaceOptionsCheckButtonTemplate" );
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox:SetSize(25,25);
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox:SetPoint ( "TOPLEFT" , UI.FCF_Count_Frame , "TOPLEFT" , 15 , -10 );
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox.Text = UI.FCF_Count_Frame.FCF_AutoShowCheckBox:CreateFontString(nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox.Text:SetPoint("LEFT" , UI.FCF_Count_Frame.FCF_AutoShowCheckBox , "RIGHT" , 2 );

        UI.FCF_Count_Frame.FCF_AutoShowCheckBox:SetScript ( "OnClick" , function(self)
            FCF_Save.Setting.autoShow = self:GetChecked();
        end);

        UI.FCF_Count_Frame.FCF_AutoShowCheckBox:SetScript ( "OnEnter" , function ( self )
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR" );
            GameTooltip:AddLine("If Disabled, just type `/flip` to reopen window." );
            GameTooltip:Show()
        end)

        UI.FCF_Count_Frame.FCF_AutoShowCheckBox:SetScript("OnLeave" , function()
            GameTooltip:Hide();
        end)

        -- Auto Vendor Rule
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox = CreateFrame ( "CheckButton" , "FCF_AutoVendorCheckBox" , UI.FCF_Count_Frame , "InterfaceOptionsCheckButtonTemplate" );
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:SetSize(25,25);
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:SetPoint ( "TOPLEFT" , UI.FCF_Count_Frame.FCF_AutoShowCheckBox , "BOTTOMLEFT" , 0 , -2 );
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox.Text = UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:CreateFontString(nil , "OVERLAY" , "GameFontWhiteTiny" );
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox.Text:SetPoint("LEFT" , UI.FCF_Count_Frame.FCF_AutoVendorCheckBox , "RIGHT" , 2 );

        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:SetScript ( "OnClick" , function(self)
            FCF_Save.Setting.autoSellFullBags = self:GetChecked();
        end);

        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:SetScript ( "OnEnter" , function ( self )
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR" );
            GameTooltip:AddLine("Vendoring will begin as bags are nearly full.\nEpic cards will not auto-sell." );
            GameTooltip:Show()
        end)

        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:SetScript("OnLeave" , function()
            GameTooltip:Hide();
        end)
        if FCF_Save.Setting.autoShow then
            UI.FCF_Count_Frame.FCF_AutoShowCheckBox:SetChecked(true);
        end
        if FCF_Save.Setting.autoSellFullBags then
            UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:SetChecked ( true );
        end

    end

        -- Placeholder for future localization so languages can be easily swapped.
    if reprocessText then
        UI.FCF_Count_Frame.TitleText:SetFont ( FCF_G.font , 24 , "THICK" );
        UI.FCF_Count_Frame.TitleText:SetText ( "Fortune Card Flipping" );
        UI.FCF_Count_Frame.CartTypeText:SetFont ( FCF_G.font , 16 );
        UI.FCF_Count_Frame.FCF_FatedTabText:SetFont ( FCF_G.font , 14 );
        UI.FCF_Count_Frame.FCF_FatedTabText:SetText ( coreCards[3].name );
        UI.FCF_Count_Frame.FCF_OmensTabText:SetFont ( FCF_G.font , 14 );
        UI.FCF_Count_Frame.FCF_OmensTabText:SetText ( coreCards[2].name );
        UI.FCF_Count_Frame.FCF_MFCTabText:SetFont ( FCF_G.font , 14 );
        UI.FCF_Count_Frame.FCF_MFCTabText:SetText ( coreCards[1].name );
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox.Text:SetFont ( FCF_G.font , 14 );
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox.Text:SetText ( "Auto-Show on Flip" );
        UI.FCF_Count_Frame.FCF_AutoShowCheckBox:SetHitRectInsets ( 0 , 0 - UI.FCF_Count_Frame.FCF_AutoShowCheckBox.Text:GetWidth() - 2 , 0 , 0 );
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox.Text:SetFont ( FCF_G.font , 14 );
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox.Text:SetText ( "Auto-Vendor Cards" );
        UI.FCF_Count_Frame.FCF_AutoVendorCheckBox:SetHitRectInsets ( 0 , 0 - UI.FCF_Count_Frame.FCF_AutoVendorCheckBox.Text:GetWidth() - 2 , 0 , 0 );

        -- Table headers
        UI.FCF_Count_Frame.ValueHeaderText:SetFont ( FCF_G.font , 16 , "THICK" );
        UI.FCF_Count_Frame.ValueHeaderText:SetText ( "Vendor(g)" );
        UI.FCF_Count_Frame.CurrentSessionHeaderText:SetFont ( FCF_G.font , 16 , "THICK" );
        UI.FCF_Count_Frame.CurrentSessionHeaderText:SetText ( "SESSION" );
        UI.FCF_Count_Frame.CurrentSessionHeaderText:SetFont ( FCF_G.font , 16 , "THICK" );
        UI.FCF_Count_Frame.HistoricalHeaderText:SetText ( "HISTORICAL" );
        UI.FCF_Count_Frame.HistoricalHeaderText:SetFont ( FCF_G.font , 16 , "THICK" );
        UI.FCF_Count_Frame.GlobalHeaderText:SetText ( "GLOBAL" );
        UI.FCF_Count_Frame.GlobalHeaderText:SetFont ( FCF_G.font , 16 , "THICK" );
        UI.FCF_Count_Frame.ProbHeaderText:SetText ( "PROBABILITY" );
        UI.FCF_Count_Frame.ProbHeaderText:SetFont ( FCF_G.font , 16 , "THICK" );

        -- Now, let's build the Table
        UI.BuildTableFontStrings( reprocessText );
        UI.SetCardValues( UI.FCF_Count_Frame.tabIndex );
    end

end

-- Method:          UI.BuildTableFontStrings ( bool )
-- What it Does:    Builds the grid of strings to be used, and the texture for the Fated recipe
-- Purpose:         One time build, but reusable to reprocess strings if necessary.
UI.BuildTableFontStrings = function( reprocessText )
    if not UI.FCF_Count_Frame.countTable then
        UI.FCF_Count_Frame.countTable = {};
    end

    for i = 1 , biggestValuesTable do

        if i == 1 and not UI.FCF_Count_Frame.FCRecipeTexture then
            -- Need to build the Texture for Fortune Cookie Recipe
            UI.FCF_Count_Frame.FCRecipeTexture = UI.FCF_Count_Frame:CreateTexture(nil,"ARTWORK");
            UI.FCF_Count_Frame.FCRecipeTexture:SetSize ( 20 , 20 );
            UI.FCF_Count_Frame.FCRecipeTexture:SetTexture(1500865);

            -- Overlay button for the hyperlink
            UI.FCF_Count_Frame.FCRecipeTextureOverlay = CreateFrame ("Button" , nil , UI.FCF_Count_Frame );
            UI.FCF_Count_Frame.FCRecipeTextureOverlay:SetSize ( 20 , 20 );
            UI.FCF_Count_Frame.FCRecipeTextureOverlay:SetPoint ( "CENTER" , UI.FCF_Count_Frame.FCRecipeTexture , "CENTER" );

            UI.FCF_Count_Frame.FCRecipeTextureOverlay:SetScript("OnEnter" , function( self )
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR" );
                GameTooltip:SetHyperlink("item:" .. 198127) -- Show item tooltip
                GameTooltip:Show()
            end)

            UI.FCF_Count_Frame.FCRecipeTextureOverlay:SetScript("OnLeave" , function()
                GameTooltip:Hide();
            end)

        end

        local textWidth = math.floor ( ( UI.FCF_Count_Frame:GetWidth() - UI.FCF_Count_Frame.ValueHeaderText:GetWidth() - 50 ) / 4 ) - 5;

        if not UI.FCF_Count_Frame.countTable[i] then
            UI.FCF_Count_Frame.countTable[i] = {};
            for j = 1 , 6 do
                table.insert ( UI.FCF_Count_Frame.countTable[i] , UI.FCF_Count_Frame:CreateFontString("nil","OVERLAY","GameFontWhiteTiny") );

                if i == 1 then
                    if j == 1 then
                        UI.FCF_Count_Frame.countTable[i][j]:SetPoint( "TOPLEFT" , UI.FCF_Count_Frame.ValueHeaderText , "BOTTOMLEFT" , 0 , -18 );

                        -- Pin the texture to the right of it.
                        UI.FCF_Count_Frame.FCRecipeTexture:SetPoint ( "LEFT" , UI.FCF_Count_Frame.countTable[i][j] , "RIGHT" , 5 , 0 );

                    elseif j == 2 then
                        UI.FCF_Count_Frame.countTable[i][j]:SetPoint( "TOP" , UI.FCF_Count_Frame.CurrentSessionHeaderText , "BOTTOM" , 0 , -18 );
                    elseif j == 3 then
                        UI.FCF_Count_Frame.countTable[i][j]:SetPoint( "TOP" , UI.FCF_Count_Frame.HistoricalHeaderText , "BOTTOM" , 0 , -18 );
                    elseif j == 4 then
                        UI.FCF_Count_Frame.countTable[i][j]:SetPoint( "TOP" , UI.FCF_Count_Frame.GlobalHeaderText , "BOTTOM" , 0 , -18 );
                    elseif j == 5 then
                        UI.FCF_Count_Frame.countTable[i][j]:SetPoint( "TOPLEFT" , UI.FCF_Count_Frame.ProbHeaderText , "BOTTOMLEFT" , 3 , -18 );
                    elseif j == 6 then
                        UI.FCF_Count_Frame.countTable[i][j]:SetPoint( "TOPLEFT" , UI.FCF_Count_Frame.ProbHeaderText , "BOTTOM" , 3 , -18 );
                    end
                else
                    UI.FCF_Count_Frame.countTable[i][j]:SetPoint("TOPLEFT" , UI.FCF_Count_Frame.countTable[i-1][j] , "BOTTOMLEFT" , 0 , -6.5 );
                end

                if j == 1 or j > 4 then
                    UI.FCF_Count_Frame.countTable[i][j]:SetJustifyH("LEFT");
                else
                    UI.FCF_Count_Frame.countTable[i][j]:SetWidth( textWidth );
                    UI.FCF_Count_Frame.countTable[i][j]:SetJustifyH("CENTER");
                end
                UI.FCF_Count_Frame.countTable[i][j]:SetWordWrap( false );

            end

        end

        if reprocessText then
            for j = 1 , 6 do
                UI.FCF_Count_Frame.countTable[i][j]:SetFont( FCF_G.font , 14 );
            end
        end

    end
end

-- Method:          UI.SetCardValues(int)
-- What it Does:    Builds the texture and title of the card type header
-- Purpose:         Compartmentalize this one variable that will change depending on tab
UI.SetCardValues = function( index )
    UI.FCF_Count_Frame.CardTypeTexture:SetTexture(coreCards[index].texture);
    UI.FCF_Count_Frame.CartTypeText:SetText(coreCards[index].name );

    local values = coreCards[index].valTable;

    if index == 3 then
        UI.FCF_Count_Frame.FCRecipeTexture:Show();
        UI.FCF_Count_Frame.FCRecipeTextureOverlay:Show();
    else
        UI.FCF_Count_Frame.FCRecipeTexture:Hide();
        UI.FCF_Count_Frame.FCRecipeTextureOverlay:Hide();
    end

    -- Set the initial Gold Values and show/hide end of table frames
    for i = 1 , #UI.FCF_Count_Frame.countTable do

        if i <= ( #values + 3 ) then
            if i <= #values then
                UI.FCF_Count_Frame.countTable[i][1]:SetText(values[i] .. "g:");
            else
                if i == #values + 1 then
                    UI.FCF_Count_Frame.countTable[i][1]:SetText("TOTAL CARDS:");
                elseif i == #values + 2 then
                    UI.FCF_Count_Frame.countTable[i][1]:SetText("TOTAL VALUE:");
                elseif i == #values + 3 then
                    UI.FCF_Count_Frame.countTable[i][1]:SetText("AVG PER CARD:");
                end
            end
            for k = 1 , 6 do
                UI.FCF_Count_Frame.countTable[i][k]:Show();
            end
        else
            for k = 1 , 6 do
                UI.FCF_Count_Frame.countTable[i][k]:Hide();
            end
        end
    end

end

-- Method:          UI.SaveCoreoPsition()
-- What it Does:    Saves the custom Flip count window
-- Purpose:         Need to manually save window positions for each session.
UI.SaveCorePosition = function()
    local side1, _ , side2 , point1 , point2 = UI.FCF_Count_Frame:GetPoint();
    FCF_Save.Setting.Position[1] = side1;
    FCF_Save.Setting.Position[2] = side2;
    FCF_Save.Setting.Position[3] = point1;
    FCF_Save.Setting.Position[4] = point2;
end

-- Method:          UI.RefreshCount ( string )
-- What it Does:    Refreshes the count for the window being shown
-- Purpose:         To properly update the text to new flip count
UI.RefreshCount = function( cardType )
    local tabIndex;

    -- Build the window if never done so far.
    if FCF_Save.Setting.autoShow and ( not UI.FCF_Count_Frame or not UI.FCF_Count_Frame:IsVisible() ) then

        cardType = cardType or "fated";
        local typeTable = { ["fated"] = 3 , ["omens"] = 2 , ["mfc"] = 1 };
        tabIndex = typeTable[cardType];

        if not UI.FCF_Count_Frame then
            UI.BuildMainWindow();
            UI.FCF_Count_Frame.tabIndex = tabIndex;
        else
            UI.FCF_Count_Frame.tabIndex = tabIndex;
            -- if Closed, then on first open
            UI.FCF_Count_Frame:Show();
        end

    elseif not FCF_Save.Setting.autoShow and not UI.FCF_Count_Frame:IsVisible() then
        return;     -- No need to process the count
    end

    tabIndex = tabIndex or UI.FCF_Count_Frame.tabIndex;

    if tabIndex == 3 then
        UI.CalculateFatedCount();
    elseif tabIndex == 2 then
        UI.CalculateOmensCount();
    elseif tabIndex == 1 then
        UI.CalculateMFCCount();
    end

end

-- Method:          UI.CalculateFatedCount()
-- What it Does:    Sums up the card count for just the fated fortune card window
-- Purpose:         Display useful information to addon user.
UI.CalculateFatedCount = function()

    local totalSession = FCF.Report.GetTotalCards(FCF_G.fatedTotal);
    local valueSession = FCF.Report.TotalFatedValue(FCF_G.fatedTotal);
    local totalHistorical = FCF.Report.GetTotalCards(FCF_Save.Fated);
    local valueHistorical = FCF.Report.TotalFatedValue(FCF_Save.Fated);
    local totalGlobal = FCF.Report.GetTotalCards(FCF_G.global.fated);
    local valueGlobal = FCF.Report.TotalFatedValue(FCF_G.global.fated);
    local totalAll = totalGlobal + totalHistorical;
    local valueAll = valueHistorical + valueGlobal;
    local avg = valueSession / totalSession;
    local avg = 0;
    local ind = 1;

    -- Current Session
    if valueSession > 0 then
        avg = valueSession / totalSession;
    end

    for i = #FCF_G.fatedTotal , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][2]:SetText(FCF_G.fatedTotal[i]);
        ind = ind + 1;
    end
    UI.FCF_Count_Frame.countTable[11][2]:SetText( totalSession );
    UI.FCF_Count_Frame.countTable[12][2]:SetText( string.format ("%.2fg" , valueSession ) );
    UI.FCF_Count_Frame.countTable[13][2]:SetText( string.format ("%.2fg" , avg ) );

    -- Historical
    avg = 0;
    if valueHistorical > 0 then
        avg = valueHistorical / totalHistorical;
    end

    ind = 1;
    for i = #FCF_Save.Fated , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][3]:SetText(FCF_Save.Fated[i]);
        ind = ind + 1;
    end

    UI.FCF_Count_Frame.countTable[11][3]:SetText( totalHistorical );
    UI.FCF_Count_Frame.countTable[12][3]:SetText( string.format ("%.2fg" , valueHistorical ) );
    UI.FCF_Count_Frame.countTable[13][3]:SetText( string.format ("%.2fg" , avg ) );

    -- Global (sum of historical and author included data)
    avg = 0;
    if valueAll > 0 then
        avg = valueAll / totalAll;
    end

    ind = 1;
    for i = #FCF_G.global.fated , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][4]:SetText(FCF_G.global.fated[i] + FCF_Save.Fated[i]);
        ind = ind + 1;
    end

    UI.FCF_Count_Frame.countTable[11][4]:SetText( totalAll );
    UI.FCF_Count_Frame.countTable[12][4]:SetText( string.format ("%.2fg" , valueAll ) );
    UI.FCF_Count_Frame.countTable[13][4]:SetText( string.format ("%.2fg" , avg ) );

    UI.FCF_Count_Frame.countTable[12][5]:SetText("");
    UI.FCF_Count_Frame.countTable[12][6]:SetText("");
    UI.FCF_Count_Frame.countTable[13][5]:SetText("");
    UI.FCF_Count_Frame.countTable[13][6]:SetText("");

    -- Probability Calculation
    local prob = 0;
    local percent = 0;
    ind = 1;
    for i = #FCF_G.global.fated , 1 , -1 do
        prob = totalAll / (FCF_G.global.fated[i] + FCF_Save.Fated[i]);

        if prob > 10 then
            prob = math.floor ( prob + 0.5 );
            UI.FCF_Count_Frame.countTable[ind][5]:SetText(string.format ("1/%s" , prob ))
        else
            UI.FCF_Count_Frame.countTable[ind][5]:SetText(string.format ("1/%.1f" , prob ));
        end

        -- Percent Prob
        percent = ( (FCF_G.global.fated[i] + FCF_Save.Fated[i]) / totalAll ) * 100;
        UI.FCF_Count_Frame.countTable[ind][6]:SetText(string.format ("(%.2f%%)" , percent ) );

        ind = ind + 1;
    end
end

-- Method:          UI.CalculateOmensCount()
-- What it Does:    Sums up the card count for just the omens fortune card window
-- Purpose:         Display useful information to addon user.
UI.CalculateOmensCount = function()

    local totalSession = FCF.Report.GetTotalCards(FCF_G.omensTotal);
    local valueSession = FCF.Report.TotalOmensValue(FCF_G.omensTotal);
    local totalHistorical = FCF.Report.GetTotalCards(FCF_Save.Omen);
    local valueHistorical = FCF.Report.TotalOmensValue(FCF_Save.Omen);
    local totalGlobal = FCF.Report.GetTotalCards(FCF_G.global.omen);
    local valueGlobal = FCF.Report.TotalOmensValue(FCF_G.global.omen);
    local totalAll = totalGlobal + totalHistorical;
    local valueAll = valueHistorical + valueGlobal;
    local avg = valueSession / totalSession;
    local avg = 0;
    local ind = 1;

    -- Current Session
    if valueSession > 0 then
        avg = valueSession / totalSession;
    end

    for i = #FCF_G.omensTotal , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][2]:SetText(FCF_G.omensTotal[i]);
        ind = ind + 1;
    end
    UI.FCF_Count_Frame.countTable[13][2]:SetText( totalSession );
    UI.FCF_Count_Frame.countTable[14][2]:SetText( string.format ("%.2fg" , valueSession ) );
    UI.FCF_Count_Frame.countTable[15][2]:SetText( string.format ("%.2fg" , avg ) );

    -- Historical
    avg = 0;
    if valueHistorical > 0 then
        avg = valueHistorical / totalHistorical;
    end

    ind = 1;
    for i = #FCF_Save.Omen , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][3]:SetText(FCF_Save.Omen[i]);
        ind = ind + 1;
    end

    UI.FCF_Count_Frame.countTable[13][3]:SetText( totalHistorical );
    UI.FCF_Count_Frame.countTable[14][3]:SetText( string.format ("%.2fg" , valueHistorical ) );
    UI.FCF_Count_Frame.countTable[15][3]:SetText( string.format ("%.2fg" , avg ) );

    -- Global (sum of historical and author included data)
    avg = 0;
    if valueAll > 0 then
        avg = valueAll / totalAll;
    end

    ind = 1;
    for i = #FCF_G.global.omen , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][4]:SetText(FCF_G.global.omen[i] + FCF_Save.Omen[i]);
        ind = ind + 1;
    end

    UI.FCF_Count_Frame.countTable[13][4]:SetText( totalAll );
    UI.FCF_Count_Frame.countTable[14][4]:SetText( string.format ("%.2fg" , valueAll ) );
    UI.FCF_Count_Frame.countTable[15][4]:SetText( string.format ("%.2fg" , avg ) );

    UI.FCF_Count_Frame.countTable[14][5]:SetText("");
    UI.FCF_Count_Frame.countTable[14][6]:SetText("");
    UI.FCF_Count_Frame.countTable[15][5]:SetText("");
    UI.FCF_Count_Frame.countTable[15][6]:SetText("");

    -- Probability Calculation
    local prob = 0;
    local percent = 0;
    ind = 1;
    for i = #FCF_G.global.omen , 1 , -1 do
        prob = totalAll / (FCF_G.global.omen[i] + FCF_Save.Omen[i]);

        if prob > 10 then
            prob = math.floor ( prob + 0.5 );
            UI.FCF_Count_Frame.countTable[ind][5]:SetText(string.format ("1/%s" , prob ))
        else
            UI.FCF_Count_Frame.countTable[ind][5]:SetText(string.format ("1/%.1f" , prob ));
        end

        -- Percent Prob
        percent = ( (FCF_G.global.omen[i] + FCF_Save.Omen[i]) / totalAll ) * 100;
        UI.FCF_Count_Frame.countTable[ind][6]:SetText(string.format ("(%.2f%%)" , percent ) );

        ind = ind + 1;
    end
end

-- Method:          UI.CalculateMFCCount()
-- What it Does:    Sums up the card count for just the mfc card window
-- Purpose:         Display useful information to addon user.
UI.CalculateMFCCount = function()

    local totalSession = FCF.Report.GetTotalCards(FCF_G.mfcTotal);
    local valueSession = FCF.Report.TotalMFCValue(FCF_G.mfcTotal);
    local totalHistorical = FCF.Report.GetTotalCards(FCF_Save.MFC);
    local valueHistorical = FCF.Report.TotalMFCValue(FCF_Save.MFC);
    local totalGlobal = FCF.Report.GetTotalCards(FCF_G.global.mfc);
    local valueGlobal = FCF.Report.TotalMFCValue(FCF_G.global.mfc);
    local totalAll = totalGlobal + totalHistorical;
    local valueAll = valueHistorical + valueGlobal;
    local avg = 0;
    local ind = 1;

    -- Current Session
    if valueSession > 0 then
        avg = valueSession / totalSession;
    end

    for i = #FCF_G.mfcTotal , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][2]:SetText(FCF_G.mfcTotal[i]);
        ind = ind + 1;
    end
    UI.FCF_Count_Frame.countTable[10][2]:SetText( totalSession );
    UI.FCF_Count_Frame.countTable[11][2]:SetText( string.format ("%.2fg" , valueSession ) );
    UI.FCF_Count_Frame.countTable[12][2]:SetText( string.format ("%.2fg" , avg ) );

    -- Historical
    avg = 0;
    if valueHistorical > 0 then
        avg = valueHistorical / totalHistorical;
    end

    ind = 1;
    for i = #FCF_Save.MFC , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][3]:SetText(FCF_Save.MFC[i]);
        ind = ind + 1;
    end

    UI.FCF_Count_Frame.countTable[10][3]:SetText( totalHistorical );
    UI.FCF_Count_Frame.countTable[11][3]:SetText( string.format ("%.2fg" , valueHistorical ) );
    UI.FCF_Count_Frame.countTable[12][3]:SetText( string.format ("%.2fg" , avg ) );

    -- Global (sum of historical and author included data)
    avg = 0;
    if valueAll > 0 then
        avg = valueAll / totalAll;
    end

    ind = 1;
    for i = #FCF_G.global.mfc , 1 , -1 do
        UI.FCF_Count_Frame.countTable[ind][4]:SetText(FCF_G.global.mfc[i] + FCF_Save.MFC[i]);
        ind = ind + 1;
    end

    UI.FCF_Count_Frame.countTable[10][4]:SetText( totalAll );
    UI.FCF_Count_Frame.countTable[11][4]:SetText( string.format ("%.2fg" , valueAll ) );
    UI.FCF_Count_Frame.countTable[12][4]:SetText( string.format ("%.2fg" , avg ) );

    UI.FCF_Count_Frame.countTable[11][5]:SetText("");
    UI.FCF_Count_Frame.countTable[11][6]:SetText("");
    UI.FCF_Count_Frame.countTable[12][5]:SetText("");
    UI.FCF_Count_Frame.countTable[12][6]:SetText("");

    -- Probability Calculation
    local prob = 0;
    local percent = 0;
    ind = 1;
    for i = #FCF_G.global.mfc , 1 , -1 do
        prob = totalAll / (FCF_G.global.mfc[i] + FCF_Save.MFC[i]);

        if prob > 10 then
            prob = math.floor ( prob + 0.5 );
            UI.FCF_Count_Frame.countTable[ind][5]:SetText(string.format ("1/%s" , prob ))
        else
            UI.FCF_Count_Frame.countTable[ind][5]:SetText(string.format ("1/%.1f" , prob ));
        end

        -- Percent Prob
        percent = ( (FCF_G.global.mfc[i] + FCF_Save.MFC[i]) / totalAll ) * 100;
        UI.FCF_Count_Frame.countTable[ind][6]:SetText(string.format ("(%.2f%%)" , percent ) );

        ind = ind + 1;
    end
end

-- Method:          UI.GenerateSpreadsheetLink()
-- What it Does:    Builds the window with an edit box displayed so the user can easily copy link
-- Purpose:         Some might be curious of the raw data
UI.GenerateSpreadsheetLink = function()
    if not UI.FCF_LinkFrame then
        UI.FCF_LinkFrame = CreateFrame ( "Frame" , "FCF_LinkFrame" , UIParent , "TranslucentFrameTemplate" );
        UI.FCF_LinkFrame.CloseButton = CreateFrame ("Button" , nil ,  UI.FCF_LinkFrame , "UIPanelCloseButton" );

        -- Frame Details
        UI.FCF_LinkFrame:SetPoint( "CENTER" , UIParent , "CENTER" );
        UI.FCF_LinkFrame:SetSize( 400 , 100 );
        UI.FCF_LinkFrame:EnableMouse ( true );
        UI.FCF_LinkFrame:SetToplevel ( true );
        UI.FCF_LinkFrame:SetFrameStrata("DIALOG");

        -- Variables
        UI.FCF_LinkFrame.tabIndex = FCF_Save.Setting.CurrentTab

        -- Close Button
        UI.FCF_LinkFrame.CloseButton:SetPoint( "TOPRIGHT" , UI.FCF_LinkFrame , "TOPRIGHT" , -4 , -4 );
        UI.FCF_LinkFrame.CloseButton:SetSize ( 26 , 26 );

        UI.FCF_LinkFrame.FCF_SpreadsheetLinkTex = UI.FCF_LinkFrame:CreateFontString(nil , "OVERLAY" , "GameFontNormal");
        UI.FCF_LinkFrame.FCF_SpreadsheetLinkTex:SetPoint("TOP" , UI.FCF_LinkFrame , "TOP" , 0 , -15 );

        -- Edit Box
        UI.FCF_LinkFrame.FCF_LinkEditBox = CreateFrame( "EditBox" , "FCF_LinkEditBox" , UI.FCF_LinkFrame , "InputBoxTemplate" );
        UI.FCF_LinkFrame.FCF_LinkEditBox:SetPoint("BOTTOM" , UI.FCF_LinkFrame , "BOTTOM" , 0 , 5 );
        UI.FCF_LinkFrame.FCF_LinkEditBox:SetSize ( UI.FCF_LinkFrame:GetWidth() - 50 , 50 );
        UI.FCF_LinkFrame.FCF_LinkEditBox:SetText(spreadSheetLink);
        local customFont = CreateFont("CustomFont")
        customFont:SetFont( FCF_G.font, 16 , '');
        UI.FCF_LinkFrame.FCF_LinkEditBox:SetFontObject(customFont)
        UI.FCF_LinkFrame.FCF_LinkEditBox:SetTextInsets( 2 , 3 , 3 , 2 );
        UI.FCF_LinkFrame.FCF_LinkEditBox:SetAutoFocus ( false );
        UI.FCF_LinkFrame.FCF_LinkEditBox:EnableMouse ( true );
        UI.FCF_LinkFrame.FCF_LinkEditBox:SetJustifyH ( "CENTER" );

        UI.FCF_LinkFrame.FCF_LinkEditBox:SetScript("OnShow" , function( self )
            self:SetText(spreadSheetLink);
            self:SetFocus();
        end);

        UI.FCF_LinkFrame.FCF_LinkEditBox:SetScript("OnHide" , function(self)
            self:ClearFocus();
        end)

        UI.FCF_LinkFrame.FCF_LinkEditBox:SetScript ( "OnEscapePressed" , function ( self )
            self:ClearFocus();
        end);

        UI.FCF_LinkFrame.FCF_LinkEditBox:SetScript ( "OnEditFocusLost" , function ( self )
            self:HighlightText ( 0 , 0 );
        end)

        UI.FCF_LinkFrame.FCF_LinkEditBox:SetScript ( "OnEditFocusGained" , function ( self )
            self:HighlightText ( 0 );
            self:SetCursorPosition ( 0 );
        end);
        UI.FCF_LinkFrame:Hide();

    end

    if not UI.FCF_LinkFrame:IsVisible() then
        UI.FCF_LinkFrame.FCF_SpreadsheetLinkTex:SetFont ( FCF_G.font , 22 , "THICK" );
        UI.FCF_LinkFrame.FCF_SpreadsheetLinkTex:SetText ( "Author Spreadsheet Link" );
        UI.FCF_LinkFrame:Show();
    else
        UI.FCF_LinkFrame:Hide();
    end

end