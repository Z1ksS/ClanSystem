local clMenu

function clanSys.ClansMenu(parent)
    if IsValid(clMenu) then clMenu:Remove() return end 

    clMenu = vgui.Create("DPanel", parent)
    clMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    clMenu:SetPos(225, 5)
    clMenu.Paint = function(pnl, w, h)
        if !clanSys.Clans then
            draw.SimpleText("There are no clans now!", "Trebuchet24", w * 0.4, h * 0.4, Color( 255, 255, 255, 255 ))
        end
    end
    
    local value = 1
    local logo = {}
    if clanSys.Clans then 
        for k, v in pairs(clanSys.Clans) do 
            local logo = clanSys.GetClanLogo(v.name)

            local clanPanel = vgui.Create("DPanel", clMenu)
            clanPanel:SetSize(clMenu:GetWide() - 10, 70)
            clanPanel:SetPos(5, 15 + (value - 1) * 90)
            clanPanel.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)

                draw.SimpleText(v.name, "Trebuchet24", 60, 10, Color( 255, 255, 255 ))

                local color = Color(clanSys.GetClanColor(v.name).r, clanSys.GetClanColor(v.name).g, clanSys.GetClanColor(v.name).b, clanSys.GetClanColor(v.name).a)
                draw.RoundedBox(1, 0, h - 2, w, 2, color)

                draw.SimpleText(clanSys.GetClanPlayers(v.name) .. " Members", "Trebuchet18", 60, 35, Color( 255, 255, 255, 255 ))
                draw.Material(0, 5, 55, 55, Material(logo), Color(255, 255, 255, 255))
            end
            
            --[[table.insert(logo, {logo = clanSys.GetClanLogo(v.name)})
            local dLogo = vgui.Create("CircularLogo", clanPanel)
            dLogo:SetSize(55, 55)
            dLogo:SetPos(0, 5)
            dLogo.index = k
            dLogo:SetImage(logo[1].logo)--]]

            value = value + 1
        end 
    end

    local createButton = vgui.Create("DButton", clMenu)
    createButton:SetSize(150, 25)
    createButton:SetPos(clMenu:GetWide() - 150, 5)
    createButton:SetText("")
    createButton.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, Color(25, 141, 104))

        draw.SimpleText("CREATE CLAN", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end     
    
end 