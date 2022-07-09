local PANEL = {}

function PANEL:Init()
    self.Icon = false 

    self.Name = "Button"

    self.lerp = 0
end 

function PANEL:SetIcon(icon)
    self.Icon = true 

    self.IconMaterial = icon 

    self.Active = false
end 

function PANEL:SetName(name)
    self.Name = name 
end 

function PANEL:Think()
    if self:IsHovered() then 
        self.lerp = math.min(1,self.lerp + FrameTime() * 4)
    else 
        self.lerp = math.max(0,self.lerp - FrameTime() * 4)
    end 
end 

function PANEL:Paint(w, h)
    draw.RoundedBox(1, 0, 0, w, h, clanSys.MainColors.MainGrey)

    --draw.RoundedBox(number cornerRadius, number x, number y, number width, number height, table color)
    if self.Icon then 
        draw.RoundedBox(1, 0, 0, 40, h, clanSys.MainColors.SecondaryGrey)
    end 

    local color = Color(clanSys.MainColors.MainBlue.r, clanSys.MainColors.MainBlue.g, clanSys.MainColors.MainBlue.b, Lerp(self.lerp, 55, 255))
    if self:IsHovered() then 

        surface.SetDrawColor( color )
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    else 
        draw.RoundedBox(1, 0, h - 2, w, 2, color)
    end 

    draw.SimpleText(self.Name, "clanSys_trebuchet_24", 1, 10, Color( 255, 255, 255 ))

    draw.RoundedBox(1, 0, h - 2, w, 2, clanSys.MainColors.MainBlue)
end 

vgui.Register("clanSys_Button_Menu", PANEL, "DButton")