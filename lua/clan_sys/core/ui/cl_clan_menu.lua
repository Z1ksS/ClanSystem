local bgMaterial = Material("materials/clan_system/background.png")
local logoMaterial = Material("materials/clan_system/logo.png")

local Frame 
function clanSys.OpenMainMenu()
    if IsValid(Frame) then Frame:Remove() return end 
    
    activepanel = "Clans"

    Frame = vgui.Create("DFrame")
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
    --mPanel:SetSize(w - 50, h - 50)
    --mPanel:SetPos(25, 25)
    mPanel:Dock(FILL)
    mPanel:DockMargin(10, 0, 20, 20)
    mPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(2, 0, 0, w, h, clanSys.MainColors.MainGrey)
    end

    if activepanel == "Clans" then  
        clanSys.ClansMenu(mPanel)
    end 

    local bTable = {
        ["Description"] = {
            func = function() clanSys.DescriptionPanel(mPanel) end,
            flags = {"description"}
        },
        ["Currency"] = {
            func = function() clanSys.CurrencyMenu(mPanel, LocalPlayer():GetPlayerClan()) end, 
            flags = {"withdraw", "deposit"}
        },
        ["Invite"] = {
            func = function() clanSys.ClansInviteMenu(mPanel) end,
            flags = {"invite"}
        },
        ["Clans"] = {
            func = function() clanSys.ClansMenu(mPanel) end,
            flags = {"all"}
        },
        ["Ranks"] = {
            func = function() clanSys.RankEditMenu(mPanel) end,
            flags = {"editgroups"}
        },
        ["Invite box"] = {
            func = function() clanSys.ClansInvitePlayerMenu(mPanel) end,
            flags = {"all"}
        },
        ["Perks"] = {
            func = function() clanSys.ClanPerksMenu(mPanel) end,
            flags = {"upgrade"}
        },
        ["Settings"] = {
            func = function() clanSys.ClansEditionMenu(mPanel, LocalPlayer():GetPlayerClan()) end,
            flags = {"editgang"}
        },
        ["Members"] = {
            func = function() clanSys.ClanMembersEdit(mPanel, LocalPlayer():GetPlayerClan()) end,
            flags = {"members"}
        },
        ["Perk Edition"] = {
            func = function() clanSys.ClansPerkEditionMenu(mPanel, LocalPlayer():GetPlayerClan()) end,
            flags = {"perkedition"}
        },
        ["Clan create"] = {
            func = function() clanSys.ClansCreateMenu(mPanel) end,
            flags = {"clancreate"}
        },
        ["Color edit"] = {
            func = function() clanSys.ClansEditionColorMenu(mPanel, LocalPlayer():GetPlayerClan()) end,
            flags = {"coloredit"}
        },
        ["Admin"] = {
            func = function() clanSys.ClansAdminPanel(mPanel) end,
            flags = {"superadmin"}
        },
        ["Currency admin"] = {
            func = function() clanSys.ClansCurrencyAdmin(mPanel, LocalPlayer():GetPlayerClan()) end,
            flags = {"superadm"}
        }
    }


    local bPanel = vgui.Create("DPanel", mPanel)
    --bPanel:SetSize(w - 1000, mPanel:GetTall() - 10)
    --bPanel:SetPos(mPanel:GetX() + 5, mPanel:GetY() + 5)
    bPanel:Dock(LEFT)
    bPanel:DockMargin(5, 5, 5, 5)
	bPanel:SetWide(clanSys.ScaleW(210))
    bPanel.Paint = function(pnl, w, h)
        draw.Material(0, 0, 334, h, bgMaterial)

        draw.Material(w * 0.1, 0, clanSys.ScaleW(158), clanSys.ScaleH(158), logoMaterial)
    end

    local bPanelScroll = vgui.Create( "DScrollPanel", bPanel )
    --bPanelScroll:SetSize(bPanel:GetWide(), bPanel:GetTall() - 20)
    --bPanelScroll:SetPos(0, 0)
    bPanelScroll:Dock(FILL)
    bPanelScroll:DockMargin(5, clanSys.ScaleH(158), 0, 5)
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

    for k, v in SortedPairs(bTable) do
        if LocalPlayer():GetPlayerPermissions() and LocalPlayer():GetPlayerPermissions()[v.flags[1]] or v.flags[2] and LocalPlayer():GetPlayerPermissions()[v.flags[2]] or v.flags[1] == "all" or v.flags[1] == "superadmin" and LocalPlayer():IsSuperAdmin() then
            local button = bPanelScroll:Add("clanSys_Button_Menu")
            --button:SetSize(clanSys.ScaleW(190), 45)
            --button:SetPos(5, 158 + (value - 1) * 55)
			button:Dock(TOP)
			button:DockMargin(5, 5, 5, 5)
			button:SetTall(clanSys.ScaleH(45))
            button:SetName(k)
            button:SetText("")

            button.DoClick = function()
                if activepanel == k then    
                    return 
                else 
                    if activepanel != "" then 
                        bTable[activepanel].func()
                    end
                    activepanel = k
                end
                v.func()
            end 
        
            value = value + 1
        end
    end 
end 

net.Receive("ClanSysOpenMenu", clanSys.OpenMainMenu)