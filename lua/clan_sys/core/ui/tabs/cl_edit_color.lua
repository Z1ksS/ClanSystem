local clEditColor

function clanSys.ClansEditionColorMenu(parent, clan)
    if IsValid(clEditColor) then clEditColor:Remove() return end 

    local saveButton

    clEditColor = vgui.Create("DPanel", parent)
    --clEditColor:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --clEditColor:SetPos(clanSys.ScaleW(225), 5)
    clEditColor:Dock(FILL)
    clEditColor:DockMargin(5, 5, 5, 5)
    clEditColor.Paint = function(pnl, w, h)
    end

    local blockBottom = vgui.Create("DPanel", clEditColor)
    blockBottom:Dock(BOTTOM)
    blockBottom:SetTall(clanSys.ScaleH(80))
    blockBottom.Paint = function(pnl, w, h)
    end

    local color = Color(clanSys.GetClanColor(clan).r, clanSys.GetClanColor(clan).g, clanSys.GetClanColor(clan).b, clanSys.GetClanColor(clan).a)
    
    local colorMixer = vgui.Create("DColorMixer", clEditColor)
    colorMixer:Dock(TOP)
    colorMixer:DockMargin(clanSys.ScaleW(50), clanSys.ScaleH(20), clanSys.ScaleW(50), clanSys.ScaleH(200))
    colorMixer:SetPalette(true) 
    colorMixer:SetAlphaBar(true) 
    colorMixer:SetWangs(true) 
    colorMixer:SetColor(color)
    colorMixer.ValueChanged = function(pnl, color) 
        saveButton:SetVisible(true)
    end 

    local buttonBack = vgui.Create("DButton", clEditColor)
    buttonBack:SetSize(clanSys.ScaleW(20), clanSys.ScaleH(20))
    buttonBack:SetPos(5, 10)
    buttonBack:SetText("")
    buttonBack.Paint = function(pnl, w, h)
        draw.SimpleText("<", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buttonBack.DoClick = function()
        clEditColor:Remove()

        clanSys.ClansEditionMenu(parent, clan)
        activepanel = "Settings"
    end 

    saveButton = vgui.Create("DButton", blockBottom)
    --saveButton:SetSize(200, 50)
    --saveButton:SetPos(clEditColor:GetWide() * 0.35, clEditColor:GetTall() - 80)
    saveButton:Dock(TOP)
    saveButton:SetWide(clanSys.ScaleW(50))
    saveButton:SetVisible(false)
    saveButton:SetText("")
    saveButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Save", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 70, 227, 56, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    saveButton.DoClick = function()
        local newColor = colorMixer:GetColor()

        net.Start("ClanSysUpdateColor")
            net.WriteTable(newColor)
            net.WriteEntity(LocalPlayer())
        net.SendToServer()

        timer.Simple(0.1, function()
            clEditColor:Remove()
            clanSys.ClansEditionColorMenu(parent, clan)

            activepanel = "Color edit"
        end)
    end 
end 