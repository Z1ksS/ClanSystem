local crMenu

local function BuildRecentPaymentsMenu(parent, clan)
    local recentPanel
    if IsValid(recentPanel) then recentPanel:Remove() return end 

    recentPanel = vgui.Create("DPanel", parent)
    --recentPanel:SetSize(parent:GetWide() / 2 - 100, parent:GetTall() - 100)
    --recentPanel:SetPos(parent:GetWide() / 2, 75)
    recentPanel:Dock(FILL)
    recentPanel:DockMargin(5, 5, 5, 5)
    recentPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, clanSys.ScaleW(50), clanSys.ScaleH(110), w - clanSys.ScaleW(50), h - clanSys.ScaleH(110), Color(135, 135, 135))

        draw.SimpleText("Recent", "clanSys_trebuchet_24", w * 0.5, h * 0.15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local paymentsScroll = vgui.Create( "DScrollPanel", recentPanel )
    --paymentsScroll:SetSize(recentPanel:GetWide() - 10, recentPanel:GetTall() - 20)
    --paymentsScroll:SetPos(5, 0)
    paymentsScroll:Dock(FILL)
    paymentsScroll:DockMargin(clanSys.ScaleW(100), clanSys.ScaleH(115), 5, 5)
    local sbar = paymentsScroll:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
    end

    for k, v in pairs(clanSys.ClanMoneyHistory) do 
        if v.clan == clan then 
            local textMain = paymentsScroll:Add("DLabel")
            --textMain:SetSize(200, 200)
	        --textMain:SetPos(paymentsScroll:GetWide() * 0.1, 45 + (k - 1) * 25)
            textMain:Dock(TOP)
            textMain:DockMargin(0, 5, 0, 5)
            --textMain:SizeToContents()
	        textMain:SetFont("clanSys_trebuchet_24")
            textMain:SetTextColor(Color(255, 255, 255, 255))
	        textMain:SetText(v.ply:Nick() .. " " .. v.typeOp .. " - ")
	        textMain:SetContentAlignment(7)
	        textMain:SetAutoStretchVertical(true)

            local xSet = 0 
            surface.SetFont("clanSys_trebuchet_24")
            local xOffSet, yOffSet = surface.GetTextSize(v.ply:Nick() .. " " .. v.typeOp .. " - ")
            if v.typeOp == "deposit" and v.amount != 1 then 
                xSet = math.Round(math.log((textMain:GetWide() - textMain:GetX()), math.abs(v.amount)), 1) + 5 
            elseif v.typeOp == "withdraw" and v.amount != 1 then 
                xSet = math.Round(math.log((textMain:GetWide() - textMain:GetX()), math.abs(v.amount)), 1) + xOffSet * 0.15 
            end

            local moneyText = textMain:Add("DLabel")
            --moneyText:SetSize(200, 200)
	        --moneyText:SetPos((textMain:GetWide() - textMain:GetX()) + xSet, 45 + (k - 1) * 25)
            moneyText:Dock(FILL)
            moneyText:DockMargin(xOffSet, 0, 0, clanSys.ScaleH(50))
	        moneyText:SetFont("clanSys_trebuchet_24")
            moneyText:SetTextColor(v.typeOp == "withdraw" and Color(142, 25, 51) or Color(70, 227, 56))
	        moneyText:SetText(DarkRP.formatMoney(tonumber(v.amount)))
	        moneyText:SetAutoStretchVertical(true)
            moneyText:SizeToContents()

            --local xOffSet, yOffSet = surface.GetTextSize(v.ply:Nick() .. " " .. v.typeOp .. " - " .. "$" .. v.amount)

            --draw.SimpleText(v.ply:Nick() .. " " .. v.typeOp .. " - ", "clanSys_trebuchet_24", w * 0.5, h * 0.15 + (k - 1) * 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            --draw.SimpleText("$" .. v.amount, "clanSys_trebuchet_24", w * 0.5 + xOffSet / 2, h * 0.15 + (k - 1) * 25, v.typeOp == "withdraw" and Color(142, 25, 51) or Color(25, 141, 104), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
    end 
end 

function clanSys.CurrencyMenu(parent, clan)
    if IsValid(crMenu) then crMenu:Remove() return end 

    crMenu = vgui.Create("DPanel", parent)
    --crMenu:SetSize(clanSys.ScaleW(1050), clanSys.ScaleH(640))
    --crMenu:SetPos(clanSys.ScaleW(225), 5)
    crMenu:Dock(FILL)
    crMenu:DockMargin(5, 5, 5, 5)
    crMenu.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, clanSys.ScaleH(20), w - 1, clanSys.ScaleH(40), Color(135, 135, 135))
        --"Currency: $" .. clanSys.GetClanCurrency(LocalPlayer():GetPlayerClan())
        local xOffSet, yOffSet = surface.GetTextSize(clan .. " - ")

        draw.SimpleText(clan .. " - ", "clanSys_trebuchet_24", w * 0.5, clanSys.ScaleH(40), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(DarkRP.formatMoney(tonumber(clanSys.GetClanCurrency(clan))), "clanSys_trebuchet_24", w * 0.5 + xOffSet * 0.5, clanSys.ScaleH(40), Color( 70, 227, 56, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local amountPanel = vgui.Create("DPanel", crMenu)
    --amountPanel:SetSize(crMenu:GetWide() / 2, crMenu:GetTall() - 100)
   -- amountPanel:SetPos(5, 75)
    amountPanel:Dock(LEFT)
    amountPanel:DockMargin(5, 5, 5, 5)
    amountPanel:SetWide(clanSys.ScaleW(500))
    amountPanel.Paint = function(pnl, w, h)
        --draw.RoundedBox(9, 0, 0, w, 50, Color(90, 90, 90))

        draw.SimpleText("Enter amount", "clanSys_trebuchet_24", w * 0.5, h * 0.15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local amountToSend = 0

    local amountTextEntry = vgui.Create("DTextEntry", amountPanel)
    --amountTextEntry:SetSize(amountPanel:GetWide() / 2, 35)
    --amountTextEntry:SetPos(amountPanel:GetWide() * 0.5 - 130, 100)
    amountTextEntry:Dock(TOP)
    amountTextEntry:DockMargin(clanSys.ScaleW(85), clanSys.ScaleH(115), clanSys.ScaleW(85), 5)
    amountTextEntry:SetTall(clanSys.ScaleH(35))
    amountTextEntry:SetNumeric(true)
    amountTextEntry:SetUpdateOnType(true)
    amountTextEntry.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        local money = pnl:GetValue()
        draw.SimpleText(DarkRP.formatMoney(tonumber(money)), "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 70, 227, 56, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        --pnl:DrawTextEntryText(Color(70, 227, 56, 255), Color(255, 255, 255, 255), Color(70, 227, 56, 255))
    end 
    amountTextEntry.OnValueChange = function(pnl, val)
        amountToSend = string.Replace(val, "$", "") 
    end 
    amountTextEntry.OnEnter = function(pnl, val)
        amountToSend = string.Replace(val, "$", "")  
    end 

    local depositButton = vgui.Create("DButton", amountPanel)
    --depositButton:SetSize(amountPanel:GetWide() / 2 - 50, 35)
    --depositButton:SetPos(amountPanel:GetWide() * 0.5 - 100, 155)
    depositButton:Dock(TOP)
    depositButton:DockMargin(clanSys.ScaleW(145), clanSys.ScaleH(5), clanSys.ScaleW(145), 5)
    depositButton:SetTall(clanSys.ScaleH(35))
    depositButton:SetText("")
    depositButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(25, 141, 104))

        draw.SimpleText("DEPOSIT", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    depositButton.DoClick = function()
        if tonumber(amountToSend) <= 1 then LocalPlayer():ChatPrint("The value of the deposited amount must be greater than one!") return end 
        if tonumber(amountToSend) > LocalPlayer():getDarkRPVar("money") then LocalPlayer():ChatPrint("You don't have enough money!") return end
        
        net.Start("ClanSysSendMoney")
            net.WriteInt(amountToSend, 32) 
            net.WriteString("deposit")
            net.WriteEntity(LocalPlayer())
            net.WriteString(clan)
        net.SendToServer() 

        table.insert(clanSys.ClanMoneyHistory, {clan = clan, ply = LocalPlayer(), typeOp = "deposit", amount = amountToSend})
        BuildRecentPaymentsMenu(crMenu)
        
        amountToSend = 0 
        amountTextEntry:SetValue("")
    end 

    if LocalPlayer():GetPlayerPermissions()["withdraw"] then 
        local withdrawButton = vgui.Create("DButton", amountPanel)
        --withdrawButton:SetSize(amountPanel:GetWide() / 2 - 50, 35)
        --withdrawButton:SetPos(amountPanel:GetWide() * 0.5 - 100, 200)
        withdrawButton:Dock(TOP)
        withdrawButton:DockMargin(clanSys.ScaleW(145), clanSys.ScaleH(5), clanSys.ScaleW(145), 5)
        withdrawButton:SetTall(clanSys.ScaleH(35))
        withdrawButton:SetText("")
        withdrawButton.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(142, 25, 51))

            draw.SimpleText("WITHDRAW", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        withdrawButton.DoClick = function()
            if tonumber(amountToSend) <= 1 then LocalPlayer():ChatPrint("The value of the wished withdraw amount must be greater than one!") return end 
            if tonumber(amountToSend) > tonumber(clanSys.GetClanCurrency(clan)) then LocalPlayer():ChatPrint("There is no enough money in clan storage!") return end

            net.Start("ClanSysSendMoney")
                net.WriteInt(amountToSend, 32) 
                net.WriteString("withdraw")
                net.WriteEntity(LocalPlayer())
                net.WriteString(clan)
            net.SendToServer()

            table.insert(clanSys.ClanMoneyHistory, {clan = clan, ply = LocalPlayer(), typeOp = "withdraw", amount = amountToSend})

            BuildRecentPaymentsMenu(crMenu, clan)
            amountToSend = 0 
            amountTextEntry:SetValue("")
        end
    end

    BuildRecentPaymentsMenu(crMenu, clan)
end