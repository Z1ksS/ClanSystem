local rPanel
local saveButton

local function BuildRank(parent, selected, grandpa)
    local clan = LocalPlayer():GetPlayerClan()

    local panelRankSetUp

    if IsValid(panelRankSetUp) then panelRankSetUp:Remove() return end 

    panelRankSetUp = vgui.Create("DPanel", parent)
    --panelRankSetUp:SetSize(clanSys.ScaleW(rPanel:GetWide() / 2 - 50), rPanel:GetTall() - 20)
    --panelRankSetUp:SetPos((rPanel:GetWide() / 2 - 50) + 100, 5)
    panelRankSetUp:Dock(FILL)
    panelRankSetUp:DockMargin(5, 5, 5, 5)
    panelRankSetUp.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(135, 135, 135))
    end

    local x, y = 0, 1

    local clanRanks = clanSys.GetClanRanks(clan)
    for k, v in pairs(clanRanks) do 
        if selected == k then 
            for i, j in pairs(v.perms) do 

                local function SendRank(bool)
                    local data = util.JSONToTable(clanSys.Clans[clanSys.GetClanIndex(clan)].ranks)
                    data[k].perms[i] = bool 
                    local dataToSend = util.TableToJSON(data)

                    local compressed_data = util.Compress( dataToSend )
                    local bytes = #compressed_data

                    local edited = {rank = k, perms = i, editor = LocalPlayer(), clan = clan}

                    net.Start("ClanSysSaveRanks")
                        net.WriteUInt( bytes, 32 )
	                    net.WriteData( compressed_data, bytes )
                        net.WriteTable(edited)
                    net.SendToServer()
                end 

                local rankNameText = ""

                local rankName = vgui.Create("DTextEntry", panelRankSetUp)
                --rankName:SetSize(panelRankSetUp:GetWide() - 10, 40)
                --rankName:SetPos(5, 35)
                rankName:Dock(FILL)
                rankName:DockMargin(5, clanSys.ScaleH(25), 5, clanSys.ScaleH(555))
                rankName:SetUpdateOnType(true)
                rankName:SetValue(v.name)
                rankName.Paint = function(pnl, w, h)
                    draw.RoundedBox(20, 0, 0, w, h, clanSys.MainColors.MainGrey)

                    local rankn = pnl:GetValue()
                    draw.SimpleText(rankn, "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end 
                rankName.OnValueChange = function(pnl, val)
                    rankNameText = val

                    clanRanks[k].name = rankNameText
                    saveButton:SetVisible(true)
                end 
                rankName.OnEnter = function(pnl, val)
                    rankNameText = val
                end 

                local priorityBox = vgui.Create("DComboBox", panelRankSetUp)
                --priorityBox:SetSize(panelRankSetUp:GetWide() - 10, 40)
                --priorityBox:SetPos(5, 80)
                priorityBox:Dock(FILL)
                priorityBox:DockMargin(5, clanSys.ScaleH(85), 5, clanSys.ScaleH(500))
                for i = 1, 5 do 
                    priorityBox:AddChoice("Priority: " .. i)
                end 
                if k == "owner" or k == "member" then 
                    priorityBox:SetEnabled(false)
                end 
                priorityBox:SetValue("Priority: " .. v.priority)
                priorityBox.OnSelect = function( pnl, ind, val )
	                clanRanks[k].priority = string.Replace(tostring(val), "Priority: ", "") 

                    saveButton:SetVisible(true)
                end

                local checkBox = vgui.Create("clanSys_CheckBox", panelRankSetUp)
                checkBox:SetSize(clanSys.ScaleW(50), clanSys.ScaleH(50))
                checkBox:SetPos(clanSys.ScaleW(155) + (x - 1) * clanSys.ScaleW(150), clanSys.ScaleH(155) + (y - 1) * clanSys.ScaleH(100))
                checkBox:SetValue(j)
                checkBox.OnChange = function(pnl, bool)

                    if LocalPlayer():GetPlayerRankPriority() > tonumber(v.priority) then 
                        Derma_Message("You can't edit rank with priority, higher than yours!", "Notice", "OK")
                        return
                    end 

                    if LocalPlayer():GetPlayerRankPriority() >= tonumber(v.priority) then 

                        Derma_Query(
                            "Are you sure about that(changes can't be canceled)",
                            "Confirmation:",
                            "Yes",
                            function() SendRank(bool) end,
	                        "No",
	                        function() pnl:SetChecked(not bool) return end
                        )
                    else 
                        SendRank(bool)
                    end 
                end 

                local checkBoxLabel = vgui.Create("DLabel", panelRankSetUp)
                checkBoxLabel:SetSize(clanSys.ScaleW(100), clanSys.ScaleH(20))
                checkBoxLabel:SetPos(clanSys.ScaleW(210) + (x - 1) * clanSys.ScaleW(150), clanSys.ScaleH(170) + (y - 1) * clanSys.ScaleH(100))
                checkBoxLabel:SetText(string.upper(i))
                checkBoxLabel:SetFont("clanSys_trebuchet_18")
                checkBoxLabel:SetColor(Color(255, 255, 255, 255))

                x = x + 1
                if x == 3 then 
                    y = y + 1
                    x = 0
                end
            end
        end
    end

    saveButton = vgui.Create("DButton", panelRankSetUp)
    --saveButton:SetSize(200, 50)
    --saveButton:SetPos(5, panelRankSetUp:GetTall() - 80)
    saveButton:Dock(FILL)
    saveButton:DockMargin(clanSys.ScaleW(40), clanSys.ScaleH(565), clanSys.ScaleW(300), 15)
    saveButton:SetVisible(false)
    saveButton:SetText("")
    saveButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Save", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 70, 227, 56, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    saveButton.DoClick = function()
        local dataToSend = util.TableToJSON(clanRanks)

        local compressed_data = util.Compress( dataToSend )
        local bytes = #compressed_data
        
        net.Start("ClanSysSaveRanksNamePrior")
            net.WriteUInt( bytes, 32 )
	        net.WriteData( compressed_data, bytes )
            net.WriteEntity(LocalPlayer())
        net.SendToServer()

        timer.Simple(0.1, function()
            rPanel:Remove()
            activepanel = ""

            clanSys.RankEditMenu(grandpa)
        end)
    end 

    local deleteRankButton = vgui.Create("DButton", panelRankSetUp)
    --deleteRankButton:SetSize(200, 50)
    --deleteRankButton:SetPos(panelRankSetUp:GetWide() * 0.5, panelRankSetUp:GetTall() - 80)
    deleteRankButton:Dock(FILL)
    deleteRankButton:DockMargin(clanSys.ScaleW(300), clanSys.ScaleH(565), clanSys.ScaleW(40), 15)
    deleteRankButton:SetText("")
    deleteRankButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Delete rank", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 142, 25, 51, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    deleteRankButton.DoClick = function()
        if selected == "owner" or selected == "member" then 
            Derma_Message("You can't delete this rank!", "Notice", "OK")
            return
        end 

        net.Start("ClanSysDeleteRank")
            net.WriteString(selected)
            net.WriteEntity(LocalPlayer())
        net.SendToServer()

        timer.Simple(0.1, function()
            --panelRankSetUp:GetParent():Remove()
            activepanel = ""

            clanSys.RankEditMenu(parent)
            activepanel = "Ranks"
            clanSys.RankEditMenu(parent)
        end)
    end 
end

function clanSys.RankEditMenu(parent)
    if IsValid(rPanel) then rPanel:Remove() return end 

    local clan = LocalPlayer():GetPlayerClan()

    local selected = "owner"

    rPanel = vgui.Create("DPanel", parent)
    --rPanel:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --rPanel:SetPos(225, 5)
    rPanel:Dock(FILL)
    rPanel:DockMargin(5, 5, 5, 5)
    rPanel.Paint = function(pnl, w, h)
    end

    local rankPanel = vgui.Create("DPanel", rPanel)
    --rankPanel:SetSize(rPanel:GetWide() / 2 - 50, rPanel:GetTall() - 20)
    --rankPanel:SetPos(5, 5)
    rankPanel:Dock(LEFT)
    rankPanel:DockMargin(5, 5, 5, 5)
    rankPanel:SetWide(clanSys.ScaleW(500))
    rankPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(135, 135, 135))
        draw.SimpleText("Ranks", "clanSys_trebuchet_24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if LocalPlayer():GetPlayerPermissions()["creategroup"] then 
        local addButton = vgui.Create("DButton", rankPanel)
        --addButton:SetSize(20, 20)
        --addButton:SetPos(rankPanel:GetWide() * 0.5 + 25, 0)
        addButton:Dock(TOP)
        addButton:DockMargin(clanSys.ScaleW(275), 0, clanSys.ScaleW(195), 5)
        addButton:SetText("")
        addButton.Paint = function(pnl, w, h)
            if pnl:IsHovered() then 
                draw.SimpleText("+", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else 
                draw.SimpleText("+", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 
        end
        addButton.DoClick = function()
            net.Start("ClanSysCreateRank")
                net.WriteEntity(LocalPlayer())
            net.SendToServer()

            timer.Simple(0.1, function()
                rPanel:Remove()
                clanSys.RankEditMenu(parent)
            end)
        end 
    end

    local rankPanelScroll = vgui.Create( "DScrollPanel", rankPanel )
    --rankPanelScroll:SetSize(rankPanel:GetWide() - 10, rankPanel:GetTall() - 20)
    --rankPanelScroll:SetPos(5, 15)
    rankPanelScroll:Dock(FILL)
    rankPanelScroll:DockMargin(5, clanSys.ScaleH(5), 5, 5)
    local sbar = rankPanelScroll:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
    end

    local value = 1
    for k, v in pairs(clanSys.GetClanRanks(clan)) do 
        local buttonRank = rankPanelScroll:Add("DButton")
        --buttonRank:SetSize(rankPanelScroll:GetWide(), 40)
        --buttonRank:SetPos(0, 25 + (value - 1) * 45)
        buttonRank:Dock(TOP)
        buttonRank:DockMargin(5, 5, 5, 5)
        buttonRank:SetTall(clanSys.ScaleH(45))
        buttonRank:SetText("")
        buttonRank.Paint = function(pnl, w, h)
            if pnl:IsHovered() or selected == k then 
                draw.SimpleText(v.name, "clanSys_trebuchet_24", w * 0.5, 15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else 
                draw.SimpleText(v.name, "clanSys_trebuchet_24", w * 0.5, 15, Color( 255, 255, 255, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 
        end
        buttonRank.DoClick = function()
            selected = k

            BuildRank(rPanel, selected, parent)
        end 

        value = value + 1
    end 

    BuildRank(rPanel, selected, parent)
end 