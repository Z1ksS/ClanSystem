local clCurrencyEdit

function clanSys.ClansCurrencyAdmin(parent, clan)
    if IsValid(clCurrencyEdit) then clCurrencyEdit:Remove() return end 

    clCurrencyEdit = vgui.Create("DPanel", parent)
    --clEditColor:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --clEditColor:SetPos(clanSys.ScaleW(225), 5)
    clCurrencyEdit:Dock(FILL)
    clCurrencyEdit:DockMargin(5, 5, 5, 5)
    clCurrencyEdit.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, clanSys.ScaleH(40), w - 1, clanSys.ScaleH(40), Color(135, 135, 135))
        local xOffSet, yOffSet = surface.GetTextSize(clan .. " - ")

        draw.SimpleText(clan .. " - ", "clanSys_trebuchet_24", w * 0.5, clanSys.ScaleH(60), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(DarkRP.formatMoney(tonumber(clanSys.GetClanCurrency(clan))), "clanSys_trebuchet_24", w * 0.5 + xOffSet * 0.5, clanSys.ScaleH(60), Color( 70, 227, 56, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local amountToSend = 0
    local amountTextEntry = vgui.Create("DTextEntry", clCurrencyEdit)
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

    local depositButton = vgui.Create("DButton", clCurrencyEdit)
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
        
        amountToSend = 0 
        amountTextEntry:SetValue("")
    end 

    local withdrawButton = vgui.Create("DButton", clCurrencyEdit)
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

        amountToSend = 0 
        amountTextEntry:SetValue("")
    end

    local buttonBack = vgui.Create("DButton", clCurrencyEdit)
    buttonBack:SetSize(clanSys.ScaleW(20), clanSys.ScaleH(20))
    buttonBack:SetPos(5, 10)
    buttonBack:SetText("")
    buttonBack.Paint = function(pnl, w, h)
        draw.SimpleText("<", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buttonBack.DoClick = function()
        clCurrencyEdit:Remove()

        clanSys.ClansEditionMenu(parent, clan)
        activepanel = "Settings"
    end 
end 