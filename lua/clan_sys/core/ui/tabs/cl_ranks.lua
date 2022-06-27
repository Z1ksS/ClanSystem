local rPanel

local function BuildRank(parent, selected)
    local clan = LocalPlayer():GetPlayerClan()

    local panelRankSetUp

    if IsValid(panelRankSetUp) then panelRankSetUp:Remove() return end 

    panelRankSetUp = vgui.Create("DPanel", parent)
    panelRankSetUp:SetSize(rPanel:GetWide() / 2 - 50, rPanel:GetTall() - 20)
    panelRankSetUp:SetPos((rPanel:GetWide() / 2 - 50) + 100, 5)
    panelRankSetUp.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(135, 135, 135))
    end

    local x, y = 0, 1
    for k, v in pairs(clanSys.GetClanRanks(clan)) do 
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

                local checkBox = vgui.Create("clanSys_CheckBox", panelRankSetUp)
                checkBox:SetSize(50, 50)
                checkBox:SetPos(155 + (x - 1) * 150, 25 + (y - 1) * 100)
                checkBox:SetValue(j)
                checkBox.OnChange = function(pnl, bool)
                    if LocalPlayer():GetPlayerRankPriority() >= v.priority then 

                        Derma_Query(
                            "Are you sure about that(changes can't be canceled)",
                            "Confirmation:",
                            "Yes",
                            function() SendRank(bool) end,
	                        "No",
	                        function() pnl:SetChecked(not bool) return end
                        )
                    end 

                end 

                local checkBoxLabel = vgui.Create("DLabel", panelRankSetUp)
                checkBoxLabel:SetSize(100, 20)
                checkBoxLabel:SetPos(210 + (x - 1) * 150, 40 + (y - 1) * 100)
                checkBoxLabel:SetText(string.upper(i))
                checkBoxLabel:SetFont("Trebuchet18")
                checkBoxLabel:SetColor(Color(255, 255, 255, 255))

                x = x + 1
                if x == 3 then 
                    y = y + 1
                    x = 0
                end
            end
        end
    end
end

function clanSys.RankEditMenu(parent)
    if IsValid(rPanel) then rPanel:Remove() return end 

    local clan = LocalPlayer():GetPlayerClan()

    local selected = "owner"
    rPanel = vgui.Create("DPanel", parent)
    rPanel:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    rPanel:SetPos(225, 5)
    rPanel.Paint = function(pnl, w, h)
    end

    local rankPanel = vgui.Create("DPanel", rPanel)
    rankPanel:SetSize(rPanel:GetWide() / 2 - 50, rPanel:GetTall() - 20)
    rankPanel:SetPos(5, 5)
    rankPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(9, 0, 20, w, h - 20, Color(135, 135, 135))
        draw.SimpleText("Ranks", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if LocalPlayer():GetPlayerPermissions()["creategroup"] then 
        local addButton = vgui.Create("DButton", rankPanel)
        addButton:SetSize(20, 20)
        addButton:SetPos(rankPanel:GetWide() * 0.5 + 25, 0)
        addButton:SetText("")
        addButton.Paint = function(pnl, w, h)
            if pnl:IsHovered() then 
                draw.SimpleText("+", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else 
                draw.SimpleText("+", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 
        end
        addButton.DoClick = function()
            net.Start("ClanSysCreateRank")
                net.WriteEntity(LocalPlayer())
            net.SendToServer()
        end 
    end

    local rankPanelScroll = vgui.Create( "DScrollPanel", rankPanel )
    rankPanelScroll:SetSize(rankPanel:GetWide() - 10, rankPanel:GetTall() - 20)
    rankPanelScroll:SetPos(5, 15)
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
        buttonRank:SetSize(rankPanelScroll:GetWide(), 40)
        buttonRank:SetPos(0, 25 + (value - 1) * 45)
        buttonRank:SetText("")
        buttonRank.Paint = function(pnl, w, h)
            if pnl:IsHovered() or selected == k then 
                draw.SimpleText(v.name, "Trebuchet24", w * 0.5, 15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else 
                draw.SimpleText(v.name, "Trebuchet24", w * 0.5, 15, Color( 255, 255, 255, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end 
        end
        buttonRank.DoClick = function()
            selected = k

            BuildRank(rPanel, selected)
        end 

        value = value + 1
    end 

    BuildRank(rPanel, selected)
end 