local admPanel 

function clanSys.ClansAdminPanel(parent)
    if IsValid(admPanel) then admPanel:Remove() return end 

    admPanel = vgui.Create("DPanel", parent)
    admPanel:Dock(FILL)
    admPanel:DockMargin(5, 5, 5, 5)
    admPanel.Paint = function(pnl, w, h)
        if table.IsEmpty(clanSys.Clans) then
            draw.SimpleText("There are no clans now!", "clanSys_trebuchet_24", w * 0.4, h * 0.4, Color( 255, 255, 255, 255 ))
        end
    end
    
    local clansScroll = vgui.Create( "DScrollPanel", admPanel )
    clansScroll:Dock(FILL)
    clansScroll:DockMargin(15, 5, 0, 5)

    local value = 1
    local logo = {}
    if clanSys.Clans then 
        for k, v in pairs(clanSys.Clans) do 
            local logo = clanSys.GetClanLogo(v.name)

            local clanPanel = clansScroll:Add("DPanel")
            clanPanel:Dock(TOP)
            clanPanel:DockMargin(5, 5, 5, 5)
            clanPanel:SetTall(65)
            clanPanel.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)

                draw.SimpleText(v.name, "clanSys_trebuchet_24", 60, 20, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                local color = Color(clanSys.GetClanColor(v.name).r, clanSys.GetClanColor(v.name).g, clanSys.GetClanColor(v.name).b, clanSys.GetClanColor(v.name).a)
                draw.RoundedBox(1, 0, h - 2, w, 2, color)

                draw.SimpleText(clanSys.GetClanPlayers(v.name) .. " Members", "clanSys_trebuchet_18", 60, 35, Color( 255, 255, 255, 255 ))

                local currency = clanSys.GetClanCurrency(v.name) 
                draw.SimpleText("Currency: " .. DarkRP.formatMoney(tonumber(currency)), "clanSys_trebuchet_18", 179, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                local wId = util.SteamIDTo64(v.owner)
                local name = ""

                steamworks.RequestPlayerInfo(wId, function( steamName )
                    name = steamName
                end )

                draw.SimpleText("Owner: " .. name, "clanSys_trebuchet_18", 179, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                draw.Material(0, 5, 55, 55, Material(logo), Color(255, 255, 255, 255))
            end
        
            local editButton = vgui.Create("DButton", clanPanel)
            editButton:Dock(TOP)
            editButton:DockMargin(clanSys.ScaleW(700), 5, 5, 5)
            editButton:SetTall(clanSys.ScaleH(25))
            editButton:SetText("")
            editButton.Paint = function(pnl, w, h)
                draw.RoundedBox(20, 0, 0, w, h, Color(25, 141, 104))

                draw.SimpleText("Edit", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 
            editButton.DoClick = function()
                admPanel:Remove()

                clanSys.ClansEditionMenu(parent, v.name)

                activepanel = "Settings"
            end 
            
            value = value + 1
        end 
    end
end 