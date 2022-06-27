local crMenu

local function BuildRecentPaymentsMenu(parent)
    local clan = LocalPlayer():GetPlayerClan()

    local recentPanel
    if IsValid(recentPanel) then recentPanel:Remove() return end 

    recentPanel = vgui.Create("DPanel", parent)
    recentPanel:SetSize(parent:GetWide() / 2 - 100, parent:GetTall() - 100)
    recentPanel:SetPos(parent:GetWide() / 2, 75)
    recentPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(135, 135, 135))

        draw.SimpleText("Recent", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local paymentsScroll = vgui.Create( "DScrollPanel", recentPanel )
    paymentsScroll:SetSize(recentPanel:GetWide() - 10, recentPanel:GetTall() - 20)
    paymentsScroll:SetPos(5, 0)
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
            textMain:SetSize(200, 200)
	        textMain:SetPos(paymentsScroll:GetWide() * 0.1, 45 + (k - 1) * 25)
	        textMain:SetFont("Trebuchet24")
            textMain:SetTextColor(Color(255, 255, 255, 255))
	        textMain:SetText(v.ply:Nick() .. " " .. v.typeOp .. " - ")
	        textMain:SetContentAlignment(7)
	        textMain:SetAutoStretchVertical(true)

            local xSet = 0 
            local xOffSet, yOffSet = surface.GetTextSize(v.ply:Nick() .. " " .. v.typeOp .. " - ")
            if v.typeOp == "deposit" and v.amount != 1 then 
                xSet = math.Round(math.log((textMain:GetWide() - textMain:GetX()), math.abs(v.amount)), 1) + 5 
            elseif v.typeOp == "withdraw" and v.amount != 1 then 
                xSet = math.Round(math.log((textMain:GetWide() - textMain:GetX()), math.abs(v.amount)), 1) + xOffSet * 0.15 
            end

            local moneyText = paymentsScroll:Add("DLabel")
            moneyText:SetSize(200, 200)
	        moneyText:SetPos((textMain:GetWide() - textMain:GetX()) + xSet, 45 + (k - 1) * 25)
	        moneyText:SetFont("Trebuchet24")
            moneyText:SetTextColor(v.typeOp == "withdraw" and Color(142, 25, 51) or Color(70, 227, 56))
	        moneyText:SetText(DarkRP.formatMoney(tonumber(v.amount)))
	        moneyText:SetContentAlignment(7)
	        moneyText:SetAutoStretchVertical(true)

            --local xOffSet, yOffSet = surface.GetTextSize(v.ply:Nick() .. " " .. v.typeOp .. " - " .. "$" .. v.amount)

            --draw.SimpleText(v.ply:Nick() .. " " .. v.typeOp .. " - ", "Trebuchet24", w * 0.5, h * 0.15 + (k - 1) * 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            --draw.SimpleText("$" .. v.amount, "Trebuchet24", w * 0.5 + xOffSet / 2, h * 0.15 + (k - 1) * 25, v.typeOp == "withdraw" and Color(142, 25, 51) or Color(25, 141, 104), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
    end 
end 

function clanSys.CurrencyMenu(parent)
    if IsValid(crMenu) then crMenu:Remove() return end 

    local clan = LocalPlayer():GetPlayerClan()

    crMenu = vgui.Create("DPanel", parent)
    crMenu:SetSize(clanSys.ScaleW(1050), clanSys.ScaleH(640))
    crMenu:SetPos(225, 5)
    crMenu.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 20, w - 30, 40, Color(135, 135, 135))
        --"Currency: $" .. clanSys.GetClanCurrency(LocalPlayer():GetPlayerClan())
        local xOffSet, yOffSet = surface.GetTextSize(clan .. " - ")

        draw.SimpleText(clan .. " - ", "Trebuchet24", w * 0.5, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(DarkRP.formatMoney(tonumber(clanSys.GetClanCurrency(clan))), "Trebuchet24", w * 0.5 + xOffSet * 0.5, 40, Color( 70, 227, 56, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local amountPanel = vgui.Create("DPanel", crMenu)
    amountPanel:SetSize(crMenu:GetWide() / 2, crMenu:GetTall() - 100)
    amountPanel:SetPos(5, 75)
    amountPanel.Paint = function(pnl, w, h)
        --draw.RoundedBox(9, 0, 0, w, 50, Color(90, 90, 90))

        draw.SimpleText("Enter amount", "Trebuchet24", w * 0.5, h * 0.15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local amountToSend = 0

    local amountTextEntry = vgui.Create("DTextEntry", amountPanel)
    amountTextEntry:SetSize(amountPanel:GetWide() / 2, 35)
    amountTextEntry:SetPos(amountPanel:GetWide() * 0.5 - 130, 100)
    amountTextEntry:SetNumeric(true)
    amountTextEntry:SetUpdateOnType(true)
    amountTextEntry.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        local money = pnl:GetValue()
        draw.SimpleText(DarkRP.formatMoney(tonumber(money)), "Trebuchet24", w * 0.5, h * 0.5, Color( 70, 227, 56, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        --pnl:DrawTextEntryText(Color(70, 227, 56, 255), Color(255, 255, 255, 255), Color(70, 227, 56, 255))
    end 
    amountTextEntry.OnValueChange = function(pnl, val)
        amountToSend = string.Replace(val, "$", "") 
    end 
    amountTextEntry.OnEnter = function(pnl, val)
        amountToSend = string.Replace(val, "$", "")  
    end 

    local depositButton = vgui.Create("DButton", amountPanel)
    depositButton:SetSize(amountPanel:GetWide() / 2 - 50, 35)
    depositButton:SetPos(amountPanel:GetWide() * 0.5 - 100, 155)
    depositButton:SetText("")
    depositButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(25, 141, 104))

        draw.SimpleText("DEPOSIT", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    depositButton.DoClick = function()
        if tonumber(amountToSend) <= 1 then LocalPlayer():ChatPrint("The value of the deposited amount must be greater than one!") return end 
        if tonumber(amountToSend) > LocalPlayer():getDarkRPVar("money") then LocalPlayer():ChatPrint("You don't have enough money!") return end
        
        net.Start("ClanSysSendMoney")
            net.WriteInt(amountToSend, 32) 
            net.WriteString("deposit")
            net.WriteEntity(LocalPlayer())
        net.SendToServer() 

        table.insert(clanSys.ClanMoneyHistory, {clan = clan, ply = LocalPlayer(), typeOp = "deposit", amount = amountToSend})
        BuildRecentPaymentsMenu(crMenu)
        
        amountToSend = 0 
        amountTextEntry:SetValue("")
    end 

    local withdrawButton = vgui.Create("DButton", amountPanel)
    withdrawButton:SetSize(amountPanel:GetWide() / 2 - 50, 35)
    withdrawButton:SetPos(amountPanel:GetWide() * 0.5 - 100, 200)
    withdrawButton:SetText("")
    withdrawButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(142, 25, 51))

        draw.SimpleText("WITHDRAW", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    withdrawButton.DoClick = function()
        if tonumber(amountToSend) <= 1 then LocalPlayer():ChatPrint("The value of the wished withdraw amount must be greater than one!") return end 
        if tonumber(amountToSend) > tonumber(clanSys.GetClanCurrency(clan)) then LocalPlayer():ChatPrint("There is no enough money in clan storage!") return end

        net.Start("ClanSysSendMoney")
            net.WriteInt(amountToSend, 32) 
            net.WriteString("withdraw")
            net.WriteEntity(LocalPlayer())
        net.SendToServer()

        table.insert(clanSys.ClanMoneyHistory, {clan = clan, ply = LocalPlayer(), typeOp = "withdraw", amount = amountToSend})

        BuildRecentPaymentsMenu(crMenu)
        amountToSend = 0 
        amountTextEntry:SetValue("")
    end

    BuildRecentPaymentsMenu(crMenu)
end