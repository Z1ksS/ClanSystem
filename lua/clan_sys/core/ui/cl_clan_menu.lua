local bgMaterial = Material("materials/clan_system/background.png")

function clanSys.OpenMainMenu()

    local Frame = vgui.Create("DFrame")
    Frame:SetSize(clanSys.ScaleW(600), clanSys.ScaleH(500))
    Frame:Center()
    Frame:SetTitle() 
    Frame:SetVisible(true) 
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(true) 
    Frame:MakePopup()
    Frame.Paint = function(pnl, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
    end

    local bTable = {
        ["Home"] = "home_panel",
        ["Jobs"] = "jobs_panel",
        ["Entities"] = "home_panel",
        ["Weapons"] = "home_panel"
    }

    local mPanel = vgui.Create("DPanel", Frame)
    mPanel:SetSize(clanSys.ScaleW(500), clanSys.ScaleH(400))
    mPanel:SetPos(0, 0)
    mPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(2, 0, 0, w, h, self.MainColors.MainGrey)
    end

    local bPanel = vgui.Create("DPanel", Frame)
    bPanel:SetSize(clanSys.ScaleW(100), mPanel:GetTall() - 10)
    bPanel:SetPos(mPanel:GetX() + 5, mPanel:GetY() + 5)
    bPanel.Paint = function(pnl, w, h)
        draw.Material(0, 0, w, h, bgMaterial)
    end
end 