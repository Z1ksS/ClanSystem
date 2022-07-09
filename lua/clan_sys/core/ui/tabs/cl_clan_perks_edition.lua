local clPerkMenu

function clanSys.ClansPerkEditionMenu(parent, clan)
    if IsValid(clPerkMenu) then clPerkMenu:Remove() return end 

    local saveButton 

    clPerkMenu = vgui.Create("DPanel", parent)
    clPerkMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    clPerkMenu:SetPos(clanSys.ScaleW(225), 5)
    clPerkMenu.Paint = function(pnl, w, h)
        draw.RoundedBox(20, w * 0.35, 10, 300, 50, Color(68, 68, 68))

        draw.SimpleText("Perks settings", "Trebuchet24", w * 0.5, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local paymentsScroll = vgui.Create( "DScrollPanel", clPerkMenu )
    paymentsScroll:SetSize(clPerkMenu:GetWide() - 10, clPerkMenu:GetTall() - 15)
    paymentsScroll:SetPos(5, 100)

    local perks = clanSys.GetPlayerPerks(clan)
    local value = 1

    for k, v in pairs(perks) do 
        if v.level > 0 then 
            local perkPanel = paymentsScroll:Add("DPanel")
            perkPanel:SetSize(400, 100)
            perkPanel:SetPos(15, 5 + (value - 1) * 60)
            perkPanel.Paint = function(pnl, w, h)
                local xResize, yResize = surface.GetTextSize("Clan " .. v.name)
                draw.RoundedBox(20, 55, 5, 300, 50, Color(68, 68, 68))

                draw.SimpleText("Clan " .. v.name, "Trebuchet24", w * 0.5, h * 0.3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 

            local checkBox = paymentsScroll:Add("clanSys_CheckBox")
            checkBox:SetSize(50, 50)
            checkBox:SetPos(0, 5 + (value - 1) * 60)
            checkBox:SetValue(v.enabled)
            checkBox.OnChange = function(pnl, bool)
                saveButton:SetVisible(true)

                perks[k].enabled = bool
            end 
            value = value + 1
        end
    end

    local buttonBack = vgui.Create("DButton", clPerkMenu)
    buttonBack:SetSize(20, 20)
    buttonBack:SetPos(5, 10)
    buttonBack:SetText("")
    buttonBack.Paint = function(pnl, w, h)
        draw.SimpleText("<", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buttonBack.DoClick = function()
        clPerkMenu:Remove()

        clanSys.ClansEditionMenu(parent, clan)
        activepanel = "Settings"
    end 

    saveButton = vgui.Create("DButton", clPerkMenu)
    saveButton:SetSize(200, 50)
    saveButton:SetPos(clPerkMenu:GetWide() * 0.35, clPerkMenu:GetTall() - 80)
    saveButton:SetVisible(false)
    saveButton:SetText("")
    saveButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Save", "Trebuchet24", w * 0.5, h * 0.5, Color( 70, 227, 56, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    saveButton.DoClick = function()
        local dataToSend = util.TableToJSON(perks)

        local compressed_data = util.Compress( dataToSend )
        local bytes = #compressed_data
        
        net.Start("ClanSysUpdateDatabase")
            net.WriteUInt( bytes, 32 )
	        net.WriteData( compressed_data, bytes )
            net.WriteEntity(LocalPlayer())
        net.SendToServer()

        timer.Simple(0.1, function()
            clPerkMenu:Remove()
            clanSys.ClansPerkEditionMenu(parent, clan)

            activepanel = "Perk Edition"
        end)
    end 
end 