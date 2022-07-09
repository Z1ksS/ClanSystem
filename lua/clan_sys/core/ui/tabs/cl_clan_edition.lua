local clEditMenu

function clanSys.ClansEditionMenu(parent, clan)
    if IsValid(clEditMenu) then clEditMenu:Remove() return end 

    local isEdited = false 
    local saveButton

    clEditMenu = vgui.Create("DPanel", parent)
    --clEditMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --clEditMenu:SetPos(clanSys.ScaleW(225), 5)
    clEditMenu:Dock(FILL)
    clEditMenu:DockMargin(5, 5, 5, 5)
    clEditMenu.Paint = function(pnl, w, h)
    end

    local clanName = clanSys.GetClanName(clan)
    
    local blockBottom = vgui.Create("DPanel", clEditMenu)
    blockBottom:Dock(BOTTOM)
    blockBottom:SetTall(clanSys.ScaleH(80))
    blockBottom.Paint = function(pnl, w, h)
    end

    local blockLeft = vgui.Create("DPanel", clEditMenu)
    blockLeft:Dock(LEFT)
    blockLeft:SetWide(clanSys.ScaleW(500))
    blockLeft.Paint = function(pnl, w, h)
    end 

    local blockRight = vgui.Create("DPanel", clEditMenu)
    blockRight:Dock(RIGHT)
    blockRight:SetWide(clanSys.ScaleW(500))
    blockRight.Paint = function(pnl, w, h)
    end 

    local bottomRightPanel = vgui.Create("DPanel", blockRight)
    bottomRightPanel:Dock(BOTTOM)
    bottomRightPanel:SetTall(clanSys.ScaleH(120))
    bottomRightPanel.Paint = function(pnl, w, h)
    end
    
    local clanNamePanel = vgui.Create("DPanel", blockLeft)
    --clanNamePanel:SetSize(clanSys.ScaleW(300), 200)
    --clanNamePanel:SetPos(50, 25)
    clanNamePanel:Dock(TOP)
    clanNamePanel:DockMargin(5, 5, 5, 5)
    clanNamePanel:SetTall(clanSys.ScaleH(125))
    clanNamePanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan Name", "clanSys_trebuchet_24", w * 0.5, h * 0.45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local clanNameText = vgui.Create("DTextEntry", clanNamePanel)
    --clanNameText:SetSize(clanNamePanel:GetWide() - 10, 35)
    --clanNameText:SetPos(5, clanNamePanel:GetTall() * 0.5 + 15)
    clanNameText:Dock(BOTTOM)
    clanNameText:DockMargin(clanSys.ScaleW(100), 5, clanSys.ScaleW(100), 5)
    clanNameText:SetTall(clanSys.ScaleH(45))
    clanNameText:SetUpdateOnType(true)
    clanNameText:SetValue(clanName)
    clanNameText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        local clanText = pnl:GetValue()
        draw.SimpleText(clanText, "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    clanNameText.OnValueChange = function(pnl, val)
        clanName = val

        isEdited = true
        saveButton:SetVisible(true)
    end 
    clanNameText.OnEnter = function(pnl, val)
        clanName = val
    end  

    local clanTag = clanSys.GetClanTag(clan)

    local clanTagPanel = vgui.Create("DPanel", blockLeft)
    --clanTagPanel:SetSize(clanSys.ScaleW(300), 200)
    --clanTagPanel:SetPos(50, 150)
    clanTagPanel:Dock(TOP)
    clanTagPanel:DockMargin(5, 5, 5, 5)
    clanTagPanel:SetTall(clanSys.ScaleH(125))
    clanTagPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan Tag", "clanSys_trebuchet_24", w * 0.5, h * 0.45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if #clanTag >= 10 then 
            draw.SimpleText("The length of the tag mustn't be bigger then 10!", "clanSys_trebuchet_18", w * 0.5, h * 0.8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local clanTagText = vgui.Create("DTextEntry", clanTagPanel)
    --clanTagText:SetSize(clanTagPanel:GetWide() - 10, 35)
    --clanTagText:SetPos(5, clanTagPanel:GetTall() * 0.5 + 15)
    clanTagText:Dock(BOTTOM)
    clanTagText:DockMargin(clanSys.ScaleW(100), 5, clanSys.ScaleW(100), 5)
    clanTagText:SetTall(clanSys.ScaleH(45))
    clanTagText:SetUpdateOnType(true)
    clanTagText:SetValue(clanTag)
    clanTagText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        local tag = pnl:GetValue()
        draw.SimpleText(tag, "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
    end 
    clanTagText.OnValueChange = function(pnl, val)
        clanTag = val

        local cPos = pnl:GetCaretPos()
        if #val > 10 then 
            clanTagText:SetValue(val:sub(1, 10))
            clanTagText:SetText(val:sub(1, 10))

            clanTagText:SetCaretPos( math.min(cPos,#val) )
        end 

        isEdited = true
        saveButton:SetVisible(true)
    end 

    local publicClanPanel = vgui.Create("DPanel", blockLeft)
    --publicClanPanel:SetSize(clanSys.ScaleW(300), 200)
    --publicClanPanel:SetPos(50, 345)
    publicClanPanel:Dock(TOP)
    publicClanPanel:DockMargin(5, 5, 5, 5)
    publicClanPanel:SetTall(clanSys.ScaleH(100))
    publicClanPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan type(public/private)", "clanSys_trebuchet_24", w * 0.5, h * 0.1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local typeClan = clanSys.GetClanPublic(clan)

    local typeClanCheckBox = vgui.Create("clanSys_CheckBox", publicClanPanel)
    --typeClanCheckBox:SetSize(50, 50)
    --typeClanCheckBox:SetPos(publicClanPanel:GetWide() * 0.5 - 20, 25)
    typeClanCheckBox:Dock(FILL)
    typeClanCheckBox:DockMargin(clanSys.ScaleW(225), clanSys.ScaleH(15), clanSys.ScaleW(225), clanSys.ScaleH(25))
    typeClanCheckBox:SetValue(typeClan)
    typeClanCheckBox.OnChange = function(pnl, bool)
        typeClan = bool

        isEdited = true
        saveButton:SetVisible(true)
    end   

    local colorEditionButton = vgui.Create("DButton", blockLeft)
    --colorEditionButton:SetSize(clanSys.ScaleW(200), 50)
    --colorEditionButton:SetPos(110, clEditMenu:GetTall() - 80)
    colorEditionButton:Dock(BOTTOM)
    colorEditionButton:DockMargin(clanSys.ScaleW(100), 5, clanSys.ScaleW(100), 5)
    colorEditionButton:SetTall(clanSys.ScaleH(50))
    colorEditionButton:SetText("")
    colorEditionButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Edit color", "clanSys_trebuchet_24", w * 0.5, h * 0.5,  Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    colorEditionButton.DoClick = function()
        clanSys.ClansEditionColorMenu(parent, clan)
        clEditMenu:Remove()

        activepanel = "Color edit"
    end 

    local imgurLink = clanSys.GetClanLogoLink(clan)
    local imgurLinkPanel = vgui.Create("DPanel", blockLeft)
    --imgurLinkPanel:SetSize(clanSys.ScaleW(300), 200)
    --imgurLinkPanel:SetPos(50, 455)
    imgurLinkPanel:Dock(BOTTOM)
    imgurLinkPanel:DockMargin(5, 5, 5, clanSys.ScaleH(65))
    imgurLinkPanel:SetTall(clanSys.ScaleH(125))
    imgurLinkPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan logo", "clanSys_trebuchet_24", w * 0.5, h * 0.45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if imgurLink != "" and !string.find(imgurLink, "https://i.imgur.com/") then 
            draw.SimpleText("The link must be to imgur png!", "clanSys_trebuchet_18", w * 0.5, h * 0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local imguLinkText = vgui.Create("DTextEntry", imgurLinkPanel)
    --imguLinkText:SetSize(imgurLinkPanel:GetWide() - 10, 35)
    --imguLinkText:SetPos(5, 25)
    imguLinkText:Dock(BOTTOM)
    imguLinkText:DockMargin(clanSys.ScaleW(100), 5, clanSys.ScaleW(100), 5)
    imguLinkText:SetTall(clanSys.ScaleH(45))
    imguLinkText:SetUpdateOnType(true)
    imguLinkText:SetValue(imgurLink)
    imguLinkText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        local link = pnl:GetValue()
        draw.SimpleText(link, "clanSys_trebuchet_18", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
    end 
    imguLinkText.OnValueChange = function(pnl, val)
        imgurLink = val

        isEdited = true
        saveButton:SetVisible(true)
    end

    local descPanel = vgui.Create("DPanel", blockRight)
    --descPanel:SetSize(clanSys.ScaleW(500), clanSys.ScaleH(350))
    --descPanel:SetPos(clanSys.ScaleW(clEditMenu:GetWide() - 500), 100)
    descPanel:Dock(TOP)
    descPanel:DockMargin(5, clanSys.ScaleH(35), 5, 5)
    descPanel:SetTall(clanSys.ScaleH(315))
    descPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 20, w, h - 20, Color(68, 68, 68))

        draw.SimpleText("Clan description", "clanSys_trebuchet_24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 

    local descTextValue = clanSys.GetClanDescription(clan)

    local descText = vgui.Create("DTextEntry", descPanel)
    --descText:SetSize(descPanel:GetWide(), descPanel:GetTall() - 20)
    --descText:SetPos(5, 20)
    descText:Dock(FILL)
    descText:DockMargin(5, 20, 5, 5)
    descText:SetUpdateOnType(true)
    descText:SetText(descTextValue)
    descText:SetFont("clanSys_trebuchet_24")
    descText:SetTextColor(Color(255,255,255))
    descText:SetPaintBackground(false)
    descText:SetMultiline(true)
    descText.OnValueChange = function(pnl, val)
        descTextValue = val

        isEdited = true
        saveButton:SetVisible(true)
    end

    local bPanelScroll = vgui.Create( "DScrollPanel", bottomRightPanel )
    --bPanelScroll:SetSize(bPanel:GetWide(), bPanel:GetTall() - 20)
    --bPanelScroll:SetPos(0, 0)
    bPanelScroll:Dock(FILL)
    bPanelScroll:DockMargin(5, 5, 5, 5)
    local sbar = bPanelScroll:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(20, 0, 20, w, h - 20, Color(68, 68, 68))
    end

    if LocalPlayer():IsSuperAdmin() or LocalPlayer():GetPlayerPermissions()["perkedition"] then 
        local perkSettings = bPanelScroll:Add("DButton")
        --perkSettings:SetSize(clanSys.ScaleW(200), 50)
        --perkSettings:SetPos(clEditMenu:GetWide() - 600, 465)
        perkSettings:Dock(TOP)
        perkSettings:DockMargin(5, 5, 5, 5)
        perkSettings:SetTall(clanSys.ScaleH(25))
        perkSettings:SetText("")
        perkSettings.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

            draw.SimpleText("Perk Setting", "clanSys_trebuchet_24", w * 0.5, h * 0.5, pnl:IsHovered() and clanSys.MainColors.MainBlue or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
        perkSettings.DoClick = function()
            clanSys.ClansPerkEditionMenu(parent, clan)
            clEditMenu:Remove()

            activepanel = "Perk Edition"
        end 
    end 
    
    local memberSettings = bPanelScroll:Add("DButton")
    --memberSettings:SetSize(clanSys.ScaleW(200), 50)
    --memberSettings:SetPos(clEditMenu:GetWide() - 400, 465)
    memberSettings:Dock(TOP)
    memberSettings:DockMargin(5, 5, 5, 5)
    memberSettings:SetTall(clanSys.ScaleH(25))
    memberSettings:SetText("")
    memberSettings.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Members", "clanSys_trebuchet_24", w * 0.5, h * 0.5, pnl:IsHovered() and clanSys.MainColors.MainBlue or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    memberSettings.DoClick = function()
        clanSys.ClanMembersEdit(parent, clan)
        clEditMenu:Remove()

        activepanel = "Members"
    end 

    if LocalPlayer():IsSuperAdmin() then 
        local currencyEdit = bPanelScroll:Add("DButton")
        --disbandClan:SetSize(clanSys.ScaleW(200), 50)
        --disbandClan:SetPos(clEditMenu:GetWide() - 200, 465)
        currencyEdit:Dock(TOP)
        currencyEdit:DockMargin(5, 5, 5, 5)
        currencyEdit:SetTall(clanSys.ScaleH(25))
        currencyEdit:SetText("")
        currencyEdit.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

            draw.SimpleText("Currency edit", "clanSys_trebuchet_24", w * 0.5, h * 0.5, pnl:IsHovered() and clanSys.MainColors.MainBlue or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
        currencyEdit.DoClick = function()
            clanSys.ClansCurrencyAdmin(parent, clan)
            clEditMenu:Remove()

            activepanel = "Currency admin"
        end 
    end

    if LocalPlayer():IsSuperAdmin() then 
        local perkEdit = bPanelScroll:Add("DButton")
        --disbandClan:SetSize(clanSys.ScaleW(200), 50)
        --disbandClan:SetPos(clEditMenu:GetWide() - 200, 465)
        perkEdit:Dock(TOP)
        perkEdit:DockMargin(5, 5, 5, 5)
        perkEdit:SetTall(clanSys.ScaleH(25))
        perkEdit:SetText("")
        perkEdit.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

            draw.SimpleText("Perks edition", "clanSys_trebuchet_24", w * 0.5, h * 0.5, pnl:IsHovered() and clanSys.MainColors.MainBlue or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
        perkEdit.DoClick = function()
            clanSys.ClanMembersEdit(parent, clan)
            clEditMenu:Remove()

            activepanel = "Members"
        end 
    end
    
    if LocalPlayer():IsSuperAdmin() or LocalPlayer():GetPlayerPermissions()["disband"] then 
        local disbandClan = bPanelScroll:Add("DButton")
        --disbandClan:SetSize(clanSys.ScaleW(200), 50)
        --disbandClan:SetPos(clEditMenu:GetWide() - 200, 465)
        disbandClan:Dock(TOP)
        disbandClan:DockMargin(5, 5, 5, 5)
        disbandClan:SetTall(clanSys.ScaleH(25))
        disbandClan:SetText("")
        disbandClan.Paint = function(pnl, w, h)
            draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

            draw.SimpleText("Disband", "clanSys_trebuchet_24", w * 0.5, h * 0.5,  Color( 142, 25, 51, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
        disbandClan.DoClick = function()
            Derma_Query(
            "Are you sure about that(changes can't be canceled)",
            "Confirmation:",
            "Yes",
            function() 
                net.Start("ClanSysDisbandClan")
                    net.WriteEntity(LocalPlayer())
                net.SendToServer()

                clanSys.OpenMainMenu()
            end,
	        "No",
	        function() return end
            )
        end 
    end

    saveButton = vgui.Create("DButton", blockBottom)
    --saveButton:SetSize(200, 50)
    --saveButton:SetPos(clEditMenu:GetWide() * 0.35, clEditMenu:GetTall() - 80)
    saveButton:Dock(TOP)
    saveButton:SetTall(clanSys.ScaleH(50))
    saveButton:SetVisible(false)
    saveButton:SetText("")
    saveButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Save", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 70, 227, 56, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    saveButton.DoClick = function()
        local tblToSend = {
            name = clanName,
            tag = clanTag, 
            link = imgurLink,
            typeClan = typeClan,
            description = descTextValue,
            ply = LocalPlayer()
        }

        net.Start("ClanSysUpdateSettings")
            net.WriteTable(tblToSend)
        net.SendToServer()

        timer.Simple(0.1, function()
            clEditMenu:Remove()
            clanSys.ClansEditionMenu(parent, clan)

            activepanel = "Settings"
        end)
    end 
end 