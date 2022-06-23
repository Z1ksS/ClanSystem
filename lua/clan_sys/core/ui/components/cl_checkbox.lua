local PANEL = {}

function PANEL:Paint(w, h)
    if self:GetChecked() then 
        draw.Arc({x = w / 2, y = h / 2}, 0, 360, w / 2, 30, 100, Color(25, 141, 104))
    else 
        draw.Arc({x = w /2 , y = h / 2}, 0, 360, w / 2, 30, 100, Color(142, 25, 51))
    end
end     

vgui.Register("clanSys_CheckBox", PANEL, "DCheckBox")