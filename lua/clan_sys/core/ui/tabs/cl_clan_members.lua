local membMenu

function clanSys.ClanMembersEdit(parent, clan)
    if IsValid(membMenu) then membMenu:Remove() return end 

    local kickMember, transferClanButton, rankSelect

    membMenu = vgui.Create("DPanel", parent)
    --membMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --membMenu:SetPos(clanSys.ScaleW(225), 5)
    membMenu:Dock(FILL)
    membMenu:DockMargin(5, 5, 5, 5)
    membMenu.Paint = function(pnl, w, h)
    end

    local blockRight = vgui.Create("DPanel", membMenu)
    blockRight:Dock(RIGHT)
    blockRight:SetWide(clanSys.ScaleW(400))
    blockRight.Paint = function(pnl, w, h)
    end 

    local blockLeft = vgui.Create("DPanel", membMenu)
    blockLeft:Dock(LEFT)
    blockLeft:SetWide(clanSys.ScaleW(500))
    blockLeft.Paint = function(pnl, w, h)
    end 

    local onlinePlayersPanel = vgui.Create("DPanel", blockLeft)
    --onlinePlayersPanel:SetSize(membMenu:GetWide() * 0.5, membMenu:GetTall() - 15)
    --onlinePlayersPanel:SetPos(5, 5)
    onlinePlayersPanel:Dock(LEFT)
    onlinePlayersPanel:SetWide(clanSys.ScaleW(500))
    onlinePlayersPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(68, 68, 68))
        draw.SimpleText("Members", "clanSys_trebuchet_24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 

    local onlineScrollPanel = vgui.Create( "DScrollPanel", onlinePlayersPanel )
    --onlineScrollPanel:SetSize(onlinePlayersPanel:GetWide() - 10, onlinePlayersPanel:GetTall() - 20)
    --onlineScrollPanel:SetPos(5, 5)
    onlineScrollPanel:Dock(FILL)
    onlineScrollPanel:DockMargin(5, 25, 5, 5)
    local sbar = onlineScrollPanel:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
    end

    local selectedPlayer

    local players = clanSys.GetClanPlayersTable(clan)
    for steamId, ply in SortedPairsByMemberValue(players, "priority", true) do 
        --if ply:GetPlayerClan() == clan then 

            local playerButton = onlineScrollPanel:Add("DButton")
            --playerButton:SetSize(onlineScrollPanel:GetWide(), 50)
            --playerButton:SetPos(5, 35 + (ind - 1) * 60)
            playerButton:Dock(TOP)
            playerButton:DockMargin(5, 5, 5, 5)
            playerButton:SetTall(clanSys.ScaleH(50))
            playerButton:SetText("")
            playerButton.lerp = 0

            playerButton.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)
                
                local id = util.SteamIDTo64(steamId)
                local name = ""

                steamworks.RequestPlayerInfo(id, function( steamName )
                    name = steamName
                end )

                draw.SimpleText(name .. " - " .. ply.rank, "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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
                selectedPlayer = steamId
                
                local clan = LocalPlayer():GetPlayerClan()
                local ranks = clanSys.GetClanRanks(clan)
                local getSelectedPlayeRank = selectedPlayer and clanSys.GetClanPlayersTable(clan)[selectedPlayer].rank or ""

                rankSelect:SetValue(getSelectedPlayeRank)
                rankSelect:SetEnabled(true)
            end 

            local id = util.SteamIDTo64(steamId)
            local avatar = vgui.Create("AvatarImage", playerButton)
	        avatar:Dock(LEFT)
            avatar:SetWide(clanSys.ScaleW(50))
            avatar:SetSteamID(id, 50)
		    --avatar:SetPlayer(ply,50)
        --end
    end 
 
    if LocalPlayer():GetPlayerPermissions()["kick"] or LocalPlayer():IsSuperAdmin() then 
        kickMember = vgui.Create("DButton", blockRight)
        --kickMember:SetSize(200, 50)
        --kickMember:SetPos(membMenu:GetWide() - 300, 250)
        kickMember:Dock(TOP)
        kickMember:DockMargin(5, clanSys.ScaleH(150), 5, 5)
        kickMember:SetTall(clanSys.ScaleH(50))
        kickMember:SetText("")
        kickMember.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

            local id = selectedPlayer and util.SteamIDTo64(selectedPlayer) or ""
            local name = ""

            steamworks.RequestPlayerInfo(id, function( steamName )
                name = steamName
            end )
            draw.SimpleText(selectedPlayer and "Kick member " .. name or "Kick member", "clanSys_trebuchet_24", 1, h * 0.5, Color( 142, 25, 51, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        kickMember.DoClick = function()
            --if !IsValid(selectedPlayer) then return end 

            local clan = LocalPlayer():GetPlayerClan()
            local ranks = clanSys.GetClanRanks(clan)
            local getSelectedPlayeRank = selectedPlayer and clanSys.GetClanPlayersTable(clan)[selectedPlayer].rank or ""
            local rankPriority = clanSys.GetClanRanks(clan)[getSelectedPlayeRank].priority
            
            if tonumber(rankPriority) <= LocalPlayer():GetPlayerRankPriority() then 
                Derma_Message("You can't kick this player!", "Notice", "OK")
                return 
            end 

            local dataToSend = {member = selectedPlayer, editor = LocalPlayer()}
            net.Start("ClanSysKickPlayer")
                net.WriteTable(dataToSend)
            net.SendToServer()

            timer.Simple(0.1, function()
                membMenu:Remove()
                clanSys.ClanMembersEdit(parent, clan)
            end)
        end 
    end 

    if LocalPlayer():GetPlayerClanRank() == "owner" or LocalPlayer():IsSuperAdmin() then 
        transferClanButton = vgui.Create("DButton", blockRight)
        --transferClanButton:SetSize(200, 50)
        --transferClanButton:SetPos(membMenu:GetWide() - 300, 325)
        transferClanButton:Dock(TOP)
        transferClanButton:DockMargin(5, 5, 5, 5)
        transferClanButton:SetTall(clanSys.ScaleH(50))
        transferClanButton:SetText("")
        transferClanButton.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

            local id = selectedPlayer and util.SteamIDTo64(selectedPlayer) or ""
            local name = ""

            steamworks.RequestPlayerInfo(id, function( steamName )
                name = steamName
            end )
            draw.SimpleText(selectedPlayer and "Transfer clan to " .. name or "Transfer clan", "clanSys_trebuchet_24", 1, h * 0.5, Color( 142, 25, 51, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        transferClanButton.DoClick = function()
            --if !IsValid(selectedPlayer) then return end 

            if !LocalPlayer():IsSuperAdmin() or selectedPlayer == LocalPlayer():SteamID() then 
                Derma_Message("You can't transfer ownership to yourself", "Notice", "OK")
                return
            end 

            local dataToSend = {member = selectedPlayer, owner = LocalPlayer()}

            local id = selectedPlayer and util.SteamIDTo64(selectedPlayer) or ""
            local name = ""

            steamworks.RequestPlayerInfo(id, function( steamName )
                name = steamName
            end )

            Derma_Query(
            "Are you sure, that you want to transfer clan to " .. name .. "s(changes can't be canceled)",
            "Confirmation:",
            "Yes",
            function() 
                net.Start("ClanSysTransferClan")
                    net.WriteTable(dataToSend)
                net.SendToServer()

                clanSys.OpenMainMenu()
            end,
	        "No",
	        function() return end
            )
        end
    end 

    if LocalPlayer():GetPlayerPermissions()["setgroup"] or LocalPlayer():IsSuperAdmin() then 
        rankSelect = vgui.Create("DComboBox", blockRight)
        rankSelect:Dock(TOP)
        rankSelect:DockMargin(5, 5, 5, 5)
        rankSelect:SetTall(clanSys.ScaleH(50))
        for k, v in pairs(clanSys.GetClanRanks(LocalPlayer():GetPlayerClan())) do 
            rankSelect:AddChoice(k)
        end 
        rankSelect:SetValue("member")
        rankSelect:SetEnabled(false)
        rankSelect.OnSelect = function( pnl, ind, val )
            local clan = LocalPlayer():GetPlayerClan()
            local ranks = clanSys.GetClanRanks(clan)
            local getSelectedPlayeRank = selectedPlayer and clanSys.GetClanPlayersTable(clan)[selectedPlayer].rank or ""
            local rankPriority = clanSys.GetClanRanks(clan)[getSelectedPlayeRank].priority

            if getSelectedPlayeRank == "owner" or tonumber(rankPriority) <= LocalPlayer():GetPlayerRankPriority() or !LocalPlayer():IsSuperAdmin() then Derma_Message("You can't change rank for this player!", "Notice", "OK") pnl:SetValue(getSelectedPlayeRank) return end

            local dataToSend = {member = selectedPlayer, owner = LocalPlayer()}

            net.Start("ClanSysChangeRank")
                --net.WriteEntity(selectedPlayer)
                net.WriteTable(dataToSend)
                net.WriteString(val)
            net.SendToServer()

            timer.Simple(0.1, function()
                membMenu:Remove()
                clanSys.ClanMembersEdit(parent, clan)
            end)
        end
    end 

    local buttonBack = vgui.Create("DButton", membMenu)
    buttonBack:SetSize(20, 20)
    buttonBack:SetPos(0, 0)
    buttonBack:SetText("")
    buttonBack.Paint = function(pnl, w, h)
        draw.SimpleText("<", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buttonBack.DoClick = function()
        membMenu:Remove()

        clanSys.ClansEditionMenu(parent, clan)

        activepanel = "Settings"
    end 
end 