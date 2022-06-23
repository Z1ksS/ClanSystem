local crMenu

function clanSys.CurrencyMenu(parent)
    if IsValid(crMenu) then crMenu:Remove() return end 

    crMenu = vgui.Create("DPanel", parent)
    crMenu:SetSize(clanSys.ScaleW(1050), clanSys.ScaleH(640))
    crMenu:SetPos(225, 5)
    crMenu.Paint = function(pnl, w, h)
        draw.SimpleText("Currency: $" .. clanSys.GetClanCurrency(LocalPlayer():GetPlayerClan()), "Trebuchet24", w * 0.45, h * 0.05, Color( 255, 255, 255, 255 ))
    end

    local depositButton = vgui.Create("DButton", crMenu)
    depositButton:SetSize(crMenu:GetWide() / 2 - 50, 50)
    depositButton:SetPos(5, 85)
    depositButton:SetText("")
    depositButton.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, Color(25, 141, 104))

        draw.SimpleText("DEPOSIT", "Trebuchet24", w * 0.4, h * 0.2, Color( 255, 255, 255, 255 ))
    end 

    local withdrawButton = vgui.Create("DButton", crMenu)
    withdrawButton:SetSize(crMenu:GetWide() / 2 - 50, 50)
    withdrawButton:SetPos(crMenu:GetWide() / 2 + 5, 85)
    withdrawButton:SetText("")
    withdrawButton.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, Color(142, 25, 51))

        draw.SimpleText("WITHDRAW", "Trebuchet24", w * 0.4, h * 0.2, Color( 255, 255, 255, 255 ))
    end 

    --[[local checkBox = vgui.Create("clanSys_CheckBox", crMenu)
    checkBox:SetSize(45, 45)
    checkBox:SetPos(crMenu:GetWide() / 2 + 5, 150)--]]
end