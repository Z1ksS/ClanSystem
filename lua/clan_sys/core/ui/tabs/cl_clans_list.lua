local clMenu

function clanSys.ClansMenu(parent)
    if IsValid(clMenu) then print("t") clMenu:Remove() return end 

    clMenu = vgui.Create("DPanel", parent)
    clMenu:SetSize(1000, 640)
    clMenu:SetPos(225, 5)
    clMenu.Paint = function(pnl, w, h)
        if !clanSys.Clans then
            draw.SimpleText("There are no clans now!", "Trebuchet24", w * 0.4, h * 0.4, Color( 255, 255, 255, 255 ))
        end
    end
    
    local value = 1
    if clanSys.Clans then 
        for k, v in pairs(clanSys.Clans) do 
            local clanPanel = vgui.Create("DPanel", clMenu)
            clanPanel:SetSize(clMenu:GetWide() - 10, 70)
            clanPanel:SetPos(5, 15 + (value - 1) * 60)
            clanPanel.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)

                draw.SimpleText(v.name, "Trebuchet24", 5, 10, Color( 255, 255, 255 ))

                draw.RoundedBox(1, 0, h - 2, w, 2, clanSys.MainColors.MainBlue)

                draw.SimpleText("Players in clan: " .. clanSys.GetClanPlayer(v.name), "Trebuchet24", w * 0.4, h * 0.4, Color( 255, 255, 255, 255 ))
            end
        end 

        value = value + 1
    end
end 