local membMenu

function clanSys.ClanMembersEdit(parent, clan)
    if IsValid(membMenu) then membMenu:Remove() return end 

    membMenu = vgui.Create("DPanel", parent)
    membMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    membMenu:SetPos(clanSys.ScaleW(225), 5)
    membMenu.Paint = function(pnl, w, h)
    end

    local onlinePlayersPanel = vgui.Create("DPanel", membMenu)
    onlinePlayersPanel:SetSize(membMenu:GetWide() * 0.5, membMenu:GetTall() - 15)
    onlinePlayersPanel:SetPos(5, 5)
    onlinePlayersPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(68, 68, 68))
        draw.SimpleText("Members", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
        if ply:GetPlayerClan() == clan then 

            local playerButton = onlineScrollPanel:Add("DButton")
            playerButton:SetSize(onlineScrollPanel:GetWide(), 50)
            playerButton:SetPos(5, 35 + (ind - 1) * 60)
            playerButton:SetText("")
            playerButton.lerp = 0

            playerButton.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)
                draw.SimpleText(ply:Name() .. " - " .. ply:GetPlayerClanRank(), "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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
    end 

    if LocalPlayer():GetPlayerPermissions()["kick"] then 
        local kickMember = vgui.Create("DButton", membMenu)
        kickMember:SetSize(200, 50)
        kickMember:SetPos(membMenu:GetWide() - 300, 250)
        kickMember:SetText("")
        kickMember.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))
            draw.SimpleText(selectedPlayer and "Kick member " .. selectedPlayer:Nick() or "Kick member", "Trebuchet24", w * 0.5, h * 0.5, Color( 142, 25, 51, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
    end 

    if LocalPlayer():GetPlayerClanRank() == "owner" then 
        local transferClanButton = vgui.Create("DButton", membMenu)
        transferClanButton:SetSize(200, 50)
        transferClanButton:SetPos(membMenu:GetWide() - 300, 325)
        transferClanButton:SetText("")
        transferClanButton.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))
            draw.SimpleText(selectedPlayer and "Transfer clan to " .. selectedPlayer:Nick() or "Transfer clan", "Trebuchet24", w * 0.5, h * 0.5, Color( 142, 25, 51, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
    end 

    local buttonBack = vgui.Create("DButton", clPerkMenu)
    buttonBack:SetSize(20, 20)
    buttonBack:SetPos(5, 5)
    buttonBack:SetText("")
    buttonBack.Paint = function(pnl, w, h)
        draw.SimpleText("<", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buttonBack.DoClick = function()
        clPerkMenu:Remove()

        clanSys.ClansEditionMenu(parent, clan)
    end 
end 