local invMenu

function clanSys.ClansInviteMenu(parent)
    if IsValid(invMenu) then invMenu:Remove() return end 

    invMenu = vgui.Create("DPanel", parent)
    invMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    invMenu:SetPos(225, 5)
    invMenu.Paint = function(pnl, w, h)
    end

    local onlinePlayersPanel = vgui.Create("DPanel", invMenu)
    onlinePlayersPanel:SetSize(invMenu:GetWide() * 0.5, invMenu:GetTall() - 15)
    onlinePlayersPanel:SetPos(5, 5)
    onlinePlayersPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(135, 135, 135))
        draw.SimpleText("Online players", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 

    local onlineScrollPanel = vgui.Create( "DScrollPanel", onlinePlayersPanel )
    onlineScrollPanel:SetSize(onlinePlayersPanel:GetWide() - 10, onlinePlayersPanel:GetTall() - 20)
    onlineScrollPanel:SetPos(5, 5)
    local sbar = onlineScrollPanel:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
    end

    local players = player.GetAll()

    local selectedPlayer
    for ind, ply in pairs(players) do 
        local playerButton = onlineScrollPanel:Add("DButton")
        playerButton:SetSize(onlineScrollPanel:GetWide(), 50)
        playerButton:SetPos(5, 35 + (ind - 1) * 60)
        playerButton:SetText("")
        playerButton.selectedPly = 0
        playerButton.lerp = 0

        playerButton.Paint = function(pnl, w, h)
            draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)
            draw.SimpleText(ply:Name(), "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            local color = Color(clanSys.MainColors.MainBlue.r, clanSys.MainColors.MainBlue.g, clanSys.MainColors.MainBlue.b, Lerp(pnl.lerp, 55, 255))
            if pnl:IsHovered() then 
                surface.SetDrawColor( color )
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            else 
                draw.RoundedBox(1, 0, h - 2, w, 2, color)
            end 

            draw.RoundedBox(1, 0, h - 2, w, 2, clanSys.MainColors.MainBlue)
        end 
        playerButton.Think = function(pnl)
            if pnl:IsHovered() then 
                pnl.lerp = math.min(1,pnl.lerp + FrameTime() * 4)
            else 
                pnl.lerp = math.max(0,pnl.lerp - FrameTime() * 4)
            end 
        end 
        playerButton.DoClick = function(pnl)
            selectedPlayer = ply
        end 

        local avatar = vgui.Create("AvatarImage", playerButton)
	    avatar:SetSize(50,50)
		avatar:SetPlayer(ply,50)
    end 

    local inviteButton = vgui.Create("DButton", invMenu)
    inviteButton:SetSize(300, 100)
    inviteButton:SetPos(invMenu:GetWide() * 0.5 + 150, invMenu:GetTall() * 0.4)
    inviteButton:SetText("")
    inviteButton.Paint = function(pnl, w, h)
        draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainBlue)
        draw.SimpleText(selectedPlayer and "Invite player " .. selectedPlayer:Nick() or "Invite", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    inviteButton.DoClick = function(pnl)
        if clanSys.Invites[selectedPlayer] == LocalPlayer():GetPlayerClan() then 
            Derma_Message("You have already sent invitation to this player", "Notice", "OK")
            return 
        end

        clanSys.Invites[selectedPlayer] = LocalPlayer():GetPlayerClan()
        
        selectedPlayer:ChatPrint("You were invited in clan " .. LocalPlayer():GetPlayerClan())

        net.Start("ClanSysInvitesSyncWithServer")
            net.WriteTable(clanSys.Invites)
        net.SendToServer()
    end 
end 