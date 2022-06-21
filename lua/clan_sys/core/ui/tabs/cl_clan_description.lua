local dsPanel

function clanSys.DescriptionPanel(parent)
    if IsValid(dsPanel) then dsPanel:Remove() return end 

    local clan = LocalPlayer():GetPlayerClan()

    dsPanel = vgui.Create("DPanel", parent)
    dsPanel:SetSize(1000, 640)
    dsPanel:SetPos(225, 5)
    dsPanel.Paint = function(pnl, w, h)
    end

    local membPanel = vgui.Create("DPanel", dsPanel)
    membPanel:SetSize(255, 150)
    membPanel:SetPos(5, 5)
    membPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, clanSys.MainColors.SecondaryGrey)

        draw.SimpleText(clanSys.GetClanPlayers(clan) .. " Member", "Trebuchet24", w * 0.35, h * 0.2, Color( 255, 255, 255, 255 ))
        draw.SimpleText(clanSys.GetClanPlayersOnline(clan) .. " Online", "Trebuchet18", w * 0.4, h * 0.4, Color( 255, 255, 255, 255 ))
    end 

    local currPanel = vgui.Create("DPanel", dsPanel)
    currPanel:SetSize(255, 150)
    currPanel:SetPos(305, 5)
    currPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, clanSys.MainColors.SecondaryGrey)

        draw.SimpleText("Currency: $" .. clanSys.GetClanCurrency(clan), "Trebuchet24", w * 0.25, h * 0.2, Color( 255, 255, 255, 255 ))
    end 

    local namePanel = vgui.Create("DPanel", dsPanel)
    namePanel:SetSize(255, 150)
    namePanel:SetPos(600, 5)
    namePanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, clanSys.MainColors.SecondaryGrey)    

        local color = Color(clanSys.GetClanColor(clan).r, clanSys.GetClanColor(clan).g, clanSys.GetClanColor(clan).b, clanSys.GetClanColor(clan).a)
        draw.SimpleText("Clan Name: " .. LocalPlayer():GetPlayerClan(), "Trebuchet24", w * 0.25, h * 0.2, color)
    end 

    local chatPanel = vgui.Create("DPanel", dsPanel)
    chatPanel:SetSize(455, 250)
    chatPanel:SetPos(5, 185)
    chatPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, clanSys.MainColors.SecondaryGrey)

        if clanSys.Messages[LocalPlayer():GetPlayerClan()] then 
            for k, v in pairs(clanSys.Messages[LocalPlayer():GetPlayerClan()]) do 
                draw.SimpleText(v.sender:Nick() .. ": " .. v.message, "Trebuchet18", 5, (h - 60) - (#clanSys.Messages[LocalPlayer():GetPlayerClan()] - k) * 15, Color( 255, 255, 255, 255 ))
            end
        end 
    end 

    local chatTextEntry = vgui.Create("DTextEntry", chatPanel)
    chatTextEntry:SetSize(chatPanel:GetWide() - 100, 35)
    chatTextEntry:SetPos(5, chatPanel:GetTall() - 40)
    chatTextEntry:SetPlaceholderText( "I am a placeholder" )
    chatTextEntry.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, clanSys.MainColors.MainGrey)

        pnl:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
    end

    local chatSend = vgui.Create("DButton", chatPanel)
    chatSend:SetSize(80, 35)
    chatSend:SetPos(chatTextEntry:GetWide() + 15, chatPanel:GetTall() - 40)
    chatSend:SetText("")
    chatSend.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, Color(25, 141, 104))

        draw.SimpleText("Send", "Trebuchet24", w * 0.25, h * 0.2, Color( 255, 255, 255, 255 ))
    end 
    chatSend.DoClick = function()
        if chatTextEntry:GetValue() then 
            net.Start("ClanSysSendChatServer")
                net.WriteString(chatTextEntry:GetValue())
            net.SendToServer()

            chatTextEntry:SetValue("")
        end 
    end 
end 