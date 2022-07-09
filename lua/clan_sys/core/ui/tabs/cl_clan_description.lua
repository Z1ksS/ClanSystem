local dsPanel

function clanSys.DescriptionPanel(parent)
    if IsValid(dsPanel) then dsPanel:Remove() return end 

    local clan = LocalPlayer():GetPlayerClan()

    dsPanel = vgui.Create("DPanel", parent)
    --dsPanel:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --dsPanel:SetPos(clanSys.ScaleW(225), 5)
    dsPanel:Dock(FILL)
    dsPanel:DockMargin(5, 5, 5, 5)
    dsPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 5, 15, w - 5, clanSys.ScaleH(50), Color(90, 90, 90))
        draw.SimpleText(clan, "clanSys_trebuchet_24", (w - 5) * 0.5, clanSys.ScaleH(40), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        --draw.Arc({x = 100, y = 200}, 0, 360, 100, 30, 100, Color(90, 90, 90))
        --local logo = Material(clanSys.GetClanLogo(clan))

        --draw.Material(50, 150, 100, 100, logo)

       -- draw.RoundedBox(9, w - clanSys.ScaleW(500), 100, clanSys.ScaleW(500), 200, Color(90, 90, 90))
        --draw.SimpleText(textWrap(clanSys.GetClanDescription(clan), "Trebuchet24", #clanSys.GetClanDescription(clan)), "Trebuchet24", w - 490, 100, Color( 255, 255, 255, 255 ))
    end

    local logoMaterial = clanSys.GetClanLogo(clan)

    local leaveButton = vgui.Create("DButton", dsPanel)
    leaveButton:Dock(BOTTOM)
    leaveButton:SetTall(clanSys.ScaleH(25))
    leaveButton:SetText("")
    leaveButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(142, 25, 51))

        draw.SimpleText("LEAVE", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    leaveButton.DoClick = function()
        if LocalPlayer():GetPlayerClanRank() == "owner" then Derma_Message("You can't leave clan because you are owner!", "Notice", "OK") return end

        Derma_Query(
            "Are you sure that you want to leave?",
            "Confirmation:",
            "Yes",
            function() 
                net.Start("ClanSysDisbandClan")
                    net.WriteEntity(LocalPlayer())
                net.SendToServer()

                clanSys.OpenMainMenu()
            end,
	        "No",
	        function() return end
        )
    end 
    
    local logo = vgui.Create("CircularLogo", dsPanel)
    --logo:SetSize(clanSys.ScaleW(200), clanSys.ScaleH(200))
    --logo:SetPos(clanSys.ScaleW(25), clanSys.ScaleH(100))
    logo:Dock(FILL)
    logo:DockMargin(5, clanSys.ScaleH(100), clanSys.ScaleW(685), clanSys.ScaleH(295))
    --logo:SetTall(clanSys.ScaleH(150))
    logo:SetImage(logoMaterial)

    local descPanel = vgui.Create("DPanel", dsPanel)
    --descPanel:SetSize(500, 200)
    --descPanel:SetPos(dsPanel:GetWide() - 500, 100)
    descPanel:Dock(FILL)
    descPanel:DockMargin(clanSys.ScaleW(500), clanSys.ScaleH(90), 5, clanSys.ScaleW(310))
    descPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, Color(90, 90, 90))
    end

    local descText = vgui.Create( "DLabel", descPanel )
	--descText:SetSize( descPanel:GetWide(), descPanel:GetTall() )
	--descText:SetPos( 3, 0 )
	descText:SetFont("clanSys_trebuchet_24")
	descText:SetText( textWrap(clanSys.GetClanDescription(clan), "clanSys_trebuchet_24", 505) )
	descText:SetAutoStretchVertical( true )
    descText:SizeToContents()

    local membPanel = vgui.Create("DPanel", dsPanel)
    --membPanel:SetSize(dsPanel:GetWide() - 10, dsPanel:GetTall() * 0.5)
    --membPanel:SetPos(5, dsPanel:GetTall() * 0.5)
    membPanel:Dock(FILL)
    membPanel:DockMargin(5, clanSys.ScaleH(360), 5, 5)
    membPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, clanSys.ScaleH(50), Color(90, 90, 90))

        draw.SimpleText("Clan members", "clanSys_trebuchet_24", (w - 5) * 0.5, clanSys.ScaleH(25), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local membScroll = vgui.Create("DScrollPanel", membPanel)
    --membScroll:SetSize(membPanel:GetWide(), membPanel:GetTall() - 10)
    --membScroll:SetPos(0, 50)
    membScroll:Dock(FILL)
    membScroll:DockMargin(5, clanSys.ScaleH(25), 5, 5)

    local x, y = 1, 1
    for k, v in pairs(clanSys.GetClanPlayersTableOnline(clan)) do 
        local sizeX, sizeY = surface.GetTextSize(v.ply:Name())
        local playerProfile = membScroll:Add("clanSys_PlayerProfile")
        playerProfile:SetSize(clanSys.ScaleW(300) * 0.8, clanSys.ScaleH(65))
        playerProfile:SetPos(5 + (x - 1) * (-(clanSys.ScaleW(300) * 0.8) - 10), clanSys.ScaleH(35) + (y - 1) * (clanSys.ScaleH(65) + 15) )
        --playerProfile:Dock(TOP)
        --playerProfile:DockMargin(5, 5, 5, 5)
        --playerProfile:SetTall(clanSys.ScaleH(50))
        playerProfile:SetPlayer(v.ply)

        x = x + 1
        if x == 5 then 
            x = 0 
            y = y + 1
        end 
    end
end 