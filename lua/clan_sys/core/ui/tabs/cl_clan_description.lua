local dsPanel

function clanSys.DescriptionPanel(parent)
    if IsValid(dsPanel) then dsPanel:Remove() return end 

    local clan = LocalPlayer():GetPlayerClan()

    dsPanel = vgui.Create("DPanel", parent)
    dsPanel:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    dsPanel:SetPos(225, 5)
    dsPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 5, 15, w - 5, 50, Color(135, 135, 135))
        draw.SimpleText(clan, "Trebuchet24", (w - 5) * 0.5, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        --draw.Arc({x = 100, y = 200}, 0, 360, 100, 30, 100, Color(90, 90, 90))
        --local logo = Material(clanSys.GetClanLogo(clan))

        --draw.Material(50, 150, 100, 100, logo)

        draw.RoundedBox(9, w - 500, 100, 500, 200, Color(90, 90, 90))
        --draw.SimpleText(textWrap(clanSys.GetClanDescription(clan), "Trebuchet24", #clanSys.GetClanDescription(clan)), "Trebuchet24", w - 490, 100, Color( 255, 255, 255, 255 ))
    end

    local logoMaterial = clanSys.GetClanLogo(clan)

    local logo = vgui.Create("CircularLogo", dsPanel)
    logo:SetSize(200, 200)
    logo:SetPos(25, 100)
    logo:SetImage(logoMaterial)

    local descPanel = vgui.Create("DPanel", dsPanel)
    descPanel:SetSize(500, 200)
    descPanel:SetPos(dsPanel:GetWide() - 500, 100)
    descPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, Color(90, 90, 90))
    end 

    local descText = vgui.Create( "DLabel", descPanel )
	descText:SetSize( descPanel:GetWide(), descPanel:GetTall() )
	descText:SetPos( 5, 0 )
	descText:SetFont("Trebuchet24")
	descText:SetText( textWrap(clanSys.GetClanDescription(clan), "Trebuchet24", 505) )
	descText:SetContentAlignment( 7 )
	descText:SetAutoStretchVertical( true )

    local membPanel = vgui.Create("DPanel", dsPanel)
    membPanel:SetSize(dsPanel:GetWide() - 10, dsPanel:GetTall() * 0.5)
    membPanel:SetPos(5, dsPanel:GetTall() * 0.5)
    membPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, 50, Color(90, 90, 90))

        draw.SimpleText("Clan members", "Trebuchet24", (w - 5) * 0.5, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 

    local membScroll = vgui.Create("DScrollPanel", membPanel)
    membScroll:SetSize(membPanel:GetWide(), membPanel:GetTall() - 10)
    membScroll:SetPos(0, 50)

    local x, y = 0, 0
    for k, v in pairs(clanSys.GetClanPlayersTableOnline(clan)) do 
        local playerProfile = membScroll:Add("clanSys_PlayerProfile")
        playerProfile:SetSize(150, 65)
        playerProfile:SetPos(50 + (x - 1) * 50, 15)
        playerProfile:SetPlayer(v.ply)

        x = x + 1
        y = y + 1
        if x == 3 then 
            x = 0 
            y = 0
        end 
    end
end 