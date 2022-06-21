local PANEL = {}

function PANEL:Paint(w, h)
    draw.RoundedBox(9, 0, 0, w, h, clanSys.MainColors.MainGrey)

    pnl:DrawTextEntryText(Color(255,255,255,240), Color(0,165,255,255), Color(255,255,255,240))
end 

vgui.Register("clanSys_TextEntry", PANEL, "DTextEntry")