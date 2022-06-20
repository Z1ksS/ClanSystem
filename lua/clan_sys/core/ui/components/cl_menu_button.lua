local PANEL = {}

function PANEL:Init()
    self.Icon = false 

    self.Name = "Button"
end 

function PANEL:SetIcon(icon)
    self.Icon = true 

    self.IconMaterial = icon 
end 

function PANEL:SetName(name)
    self.Name = name 
end 

function PANEL:Paint(w, h)
    draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)

    if self.Icon then 
        draw.RoundedBox(1, 1, 0, 7, h, clanSys.MainColors.SecondaryGrey)
    end 

    draw.SimpleText(self.Name, "Trebuchet24", w * 0.3, h * 0.5, Color( 255, 255, 255 ))

    draw.RoundedBox(1, 0, h - 5, 2, 2, clanSys.MainColors.MainBlue)
end 

vgui.Register("clanSys_Button_Menu", PANEL, "DButton")