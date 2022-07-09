local clMenu

function clanSys.ClansMenu(parent)
    if IsValid(clMenu) then clMenu:Remove() return end 

    clMenu = vgui.Create("DPanel", parent)
    --clMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --clMenu:SetPos(clanSys.ScaleW(225), 5)
    clMenu:Dock(FILL)
    clMenu:DockMargin(5, 5, 5, 5)
    clMenu.Paint = function(pnl, w, h)
        if table.IsEmpty(clanSys.Clans) then
            draw.SimpleText("There are no clans now!", "clanSys_trebuchet_24", w * 0.4, h * 0.4, Color( 255, 255, 255, 255 ))
        end
    end
    
    local clansScroll = vgui.Create( "DScrollPanel", clMenu )
    clansScroll:Dock(FILL)
    clansScroll:DockMargin(15, 5, 0, 5)

    local value = 1
    local logo = {}
    if clanSys.Clans then 
        for k, v in pairs(clanSys.Clans) do 
            local logo = clanSys.GetClanLogo(v.name)

            local clanPanel = clansScroll:Add("DPanel")
            --clanPanel:SetSize(clMenu:GetWide() - 10, 70)
            --clanPanel:SetPos(5, 45 + (value - 1) * 90)
            clanPanel:Dock(TOP)
            clanPanel:DockMargin(5, 5, 5, 5)
            clanPanel:SetTall(65)
            clanPanel.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)

                draw.SimpleText(v.name, "clanSys_trebuchet_24", 60, 10, Color( 255, 255, 255 ))

                local color = Color(clanSys.GetClanColor(v.name).r, clanSys.GetClanColor(v.name).g, clanSys.GetClanColor(v.name).b, clanSys.GetClanColor(v.name).a)
                draw.RoundedBox(1, 0, h - 2, w, 2, color)

                draw.SimpleText(clanSys.GetClanPlayers(v.name) .. " Members", "clanSys_trebuchet_18", 60, 35, Color( 255, 255, 255, 255 ))
                draw.Material(0, 5, 55, 55, Material(logo), Color(255, 255, 255, 255))
            end
        

            value = value + 1
        end 
    end

    local createButton = vgui.Create("DButton", clMenu)
    --createButton:SetSize(clanSys.ScaleW(150), clanSys.ScaleH(25))
    --createButton:SetPos(clMenu:GetWide() - clanSys.ScaleW(150), 5)
    createButton:Dock(TOP)
    createButton:DockMargin(clanSys.ScaleW(750), 5, 5, 5)
    createButton:SetTall(clanSys.ScaleH(20))
    createButton:SetText("")
    createButton.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 0, w, h, Color(25, 141, 104))

        draw.SimpleText("CREATE CLAN", "clanSys_trebuchet_18", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end   
    createButton.DoClick = function()
        if LocalPlayer():GetPlayerClan() then Derma_Message("You are currently in a clan! Leave or disband your current clan, to create your own!", "Notice", "OK") return end

        clMenu:Remove()
        clanSys.ClansCreateMenu(parent)
        
        activepanel = "Clan create" 
    end   
    
end 