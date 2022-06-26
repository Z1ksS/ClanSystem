local invPlayerMenu

function clanSys.ClansInvitePlayerMenu(parent)
    if IsValid(invPlayerMenu) then invPlayerMenu:Remove() return end 

    invPlayerMenu = vgui.Create("DPanel", parent)
    invPlayerMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    invPlayerMenu:SetPos(225, 5)
    invPlayerMenu.Paint = function(pnl, w, h)
        if !clanSys.Invites[LocalPlayer()] then 
            draw.SimpleText("You have no invitations!", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
    end

    local value = 1
    if clanSys.Invites[LocalPlayer()] then 
        for k, v in pairs(clanSys.Invites) do 
            if k:Nick() != LocalPlayer():Nick() or k:GetPlayerClan() then return end 

            local logo = clanSys.GetClanLogo(v)

            local clanPanel = vgui.Create("DPanel", invPlayerMenu)
            clanPanel:SetSize(invPlayerMenu:GetWide() - 10, 70)
            clanPanel:SetPos(5, 45 + (value - 1) * 90)
            clanPanel.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)

                draw.SimpleText(v, "Trebuchet24", 60, 10, Color( 255, 255, 255 ))

                local color = Color(clanSys.GetClanColor(v).r, clanSys.GetClanColor(v).g, clanSys.GetClanColor(v).b, clanSys.GetClanColor(v).a)
                draw.RoundedBox(1, 0, h - 2, w, 2, color)

                draw.SimpleText(clanSys.GetClanPlayers(v) .. " Members", "Trebuchet18", 60, 35, Color( 255, 255, 255, 255 ))
                draw.Material(0, 5, 55, 55, Material(logo), Color(255, 255, 255, 255))
            end

            local acceptButton = vgui.Create("DButton", clanPanel)
            acceptButton:SetSize(75, 25)
            acceptButton:SetPos(clanPanel:GetWide() - 75, 5)
            acceptButton:SetText("")
            acceptButton.Paint = function(pnl, w, h)
                draw.RoundedBox(20, 0, 0, w, h, Color(25, 141, 104))

                draw.SimpleText("Accept", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 
            acceptButton.DoClick = function()
                net.Start("ClanSysAcceptInvite")
                    net.WriteString(v)
                    net.WriteEntity(LocalPlayer())
                net.SendToServer()

                table.RemoveByValue(clanSys.Invites, v)
                parent:Remove()
                clanSys.OpenMainMenu()
            end 

            local declineButton = vgui.Create("DButton", clanPanel)
            declineButton:SetSize(75, 25)
            declineButton:SetPos(clanPanel:GetWide() - 75, 35)
            declineButton:SetText("")
            declineButton.Paint = function(pnl, w, h)
                draw.RoundedBox(20, 0, 0, w, h, Color(142, 25, 51))

                draw.SimpleText("Decline", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 
            declineButton.DoClick = function()
                table.RemoveByValue(clanSys.Invites, v)
                invPlayerMenu:Remove()
                clanSys.ClansInvitePlayerMenu(parent)
            end 
            value = value + 1
        end 
    end
end 