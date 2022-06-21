local bgMaterial = Material("materials/clan_system/background.png")
local logoMaterial = Material("materials/clan_system/logo.png")

function clanSys.OpenMainMenu()
    local activepanel = "Clans"
    
    local Frame = vgui.Create("DFrame")
    Frame:SetSize(clanSys.ScaleW(1300), clanSys.ScaleH(700))
    Frame:Center()
    Frame:SetTitle("") 
    Frame:SetVisible(true) 
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(true) 
    Frame:MakePopup()
    Frame.Paint = function(pnl, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
    end

    local mPanel = vgui.Create("DPanel", Frame)
    mPanel:SetSize(1250, 650)
    mPanel:SetPos(25, 25)
    mPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(2, 0, 0, w, h, clanSys.MainColors.MainGrey)
    end

    local bTable = {
        ["Description"] = {
            func = function() clanSys.ClansMenu(mPanel) end,
            flags = {"description"}
        },
        ["Clans"] = {
            func = function() clanSys.ClansMenu(mPanel) end,
            flags = {"all"}
        }
        --[[["Description"] = "all",
        ["Members"] = "all",
        ["Invite"] = "all",
        ["Currency"] = "all",
        ["Perks"] = "all",
        ["Name & Color"] = "all",
        ["Description"] = "all",
        ["Members"] = "all",
        ["Ranks"] = "all",
        ["Logs"] = "all",
        ["Abandon Clan"] = "all",
        ["Admin menu"] = "all",--]]
    }


    local bPanel = vgui.Create("DPanel", Frame)
    bPanel:SetSize(200, mPanel:GetTall() - 10)
    bPanel:SetPos(mPanel:GetX() + 5, mPanel:GetY() + 5)
    bPanel.Paint = function(pnl, w, h)
        draw.Material(0, 0, 334, h, bgMaterial)

        draw.Material(w * 0.1, 0, 158, 158, logoMaterial)
    end

    local bPanelScroll = vgui.Create( "DScrollPanel", bPanel )
    bPanelScroll:SetSize(mPanel:GetWide(), mPanel:GetTall() - 20)
    bPanelScroll:SetPos(0, 0)
    local sbar = bPanelScroll:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
    end


    local value = 1
    for k, v in pairs(bTable) do
        if LocalPlayer():GetPlayerPermissions() and LocalPlayer():GetPlayerPermissions()[v.flags[1]] or v.flags[1] == "all" then
            local button = bPanelScroll:Add("clanSys_Button_Menu")
            button:SetSize(190, 45)
            button:SetPos(5, 158 + (value - 1) * 55)
            button:SetName(k)
            button:SetText("")

            button.DoClick = function()
                clanSys.DescriptionPanel(mPanel)
            
                if activepanel == k then 
                    activepanel = ""
                else 
                    activepanel = k
                end
            end 
        
            value = value + 1
        end
    end 
end 