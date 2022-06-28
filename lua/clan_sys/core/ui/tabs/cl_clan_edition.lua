local clEditMenu

function clanSys.ClansEditionMenu(parent, clan)
    if IsValid(clEditMenu) then clEditMenu:Remove() return end 

    local isEdited = false 
    local saveButton

    clEditMenu = vgui.Create("DPanel", parent)
    clEditMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    clEditMenu:SetPos(clanSys.ScaleW(225), 5)
    clEditMenu.Paint = function(pnl, w, h)
    end

    local clanName = clanSys.GetClanName(clan)

    local clanNamePanel = vgui.Create("DPanel", clEditMenu)
    clanNamePanel:SetSize(300, 200)
    clanNamePanel:SetPos(50, 25)
    clanNamePanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan Name", "Trebuchet24", w * 0.5, h * 0.45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local clanNameText = vgui.Create("DTextEntry", clanNamePanel)
    clanNameText:SetSize(clanNamePanel:GetWide() - 10, 35)
    clanNameText:SetPos(5, clanNamePanel:GetTall() * 0.5 + 15)
    clanNameText:SetUpdateOnType(true)
    clanNameText:SetValue(clanName)
    clanNameText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        local clanText = pnl:GetValue()
        draw.SimpleText(clanText, "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

    local clanTagPanel = vgui.Create("DPanel", clEditMenu)
    clanTagPanel:SetSize(300, 200)
    clanTagPanel:SetPos(50, 150)
    clanTagPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan Tag", "Trebuchet24", w * 0.5, h * 0.45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if #clanTag >= 10 then 
            draw.SimpleText("The length of the tag mustn't be bigger then 10!", "Trebuchet18", w * 0.5, h * 0.8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local clanTagText = vgui.Create("DTextEntry", clanTagPanel)
    clanTagText:SetSize(clanTagPanel:GetWide() - 10, 35)
    clanTagText:SetPos(5, clanTagPanel:GetTall() * 0.5 + 15)
    clanTagText:SetUpdateOnType(true)
    clanTagText:SetValue(clanTag)
    clanTagText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        local tag = pnl:GetValue()
        draw.SimpleText(tag, "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
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

    local publicClanPanel = vgui.Create("DPanel", clEditMenu)
    publicClanPanel:SetSize(300, 200)
    publicClanPanel:SetPos(50, 345)
    publicClanPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan type(public/private)", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local typeClan = clanSys.GetClanPublic(clan)

    local typeClanCheckBox = vgui.Create("clanSys_CheckBox", publicClanPanel)
    typeClanCheckBox:SetSize(50, 50)
    typeClanCheckBox:SetPos(publicClanPanel:GetWide() * 0.5 - 20, 25)
    typeClanCheckBox:SetValue(typeClan)
    typeClanCheckBox.OnChange = function(pnl, bool)
        typeClan = bool

        isEdited = true
        saveButton:SetVisible(true)
    end   

    local imgurLink = clanSys.GetClanLogoLink(clan)
    local imgurLinkPanel = vgui.Create("DPanel", clEditMenu)
    imgurLinkPanel:SetSize(300, 200)
    imgurLinkPanel:SetPos(50, 455)
    imgurLinkPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan logo", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if imgurLink != "" and !string.find(imgurLink, "https://i.imgur.com/") then 
            draw.SimpleText("The link must be to imgur png!", "Trebuchet18", w * 0.5, h * 0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local imguLinkText = vgui.Create("DTextEntry", imgurLinkPanel)
    imguLinkText:SetSize(imgurLinkPanel:GetWide() - 10, 35)
    imguLinkText:SetPos(5, 25)
    imguLinkText:SetUpdateOnType(true)
    imguLinkText:SetValue(imgurLink)
    imguLinkText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        local link = pnl:GetValue()
        draw.SimpleText(link, "Trebuchet18", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
    end 
    imguLinkText.OnValueChange = function(pnl, val)
        imgurLink = val

        isEdited = true
        saveButton:SetVisible(true)
    end

    local descPanel = vgui.Create("DPanel", clEditMenu)
    descPanel:SetSize(clanSys.ScaleW(500), clanSys.ScaleH(350))
    descPanel:SetPos(clEditMenu:GetWide() - 500, 100)
    descPanel.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 20, w, h - 20, Color(68, 68, 68))

        draw.SimpleText("Clan description", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 

    local descTextValue = clanSys.GetClanDescription(clan)

    local descText = vgui.Create("DTextEntry", descPanel)
    descText:SetSize(descPanel:GetWide(), descPanel:GetTall() - 20)
    descText:SetPos(5, 20)
    descText:SetUpdateOnType(true)
    descText:SetText(descTextValue)
    descText:SetFont("Trebuchet24")
    descText:SetTextColor(Color(255,255,255))
    descText:SetPaintBackground(false)
    descText:SetMultiline(true)
    descText.OnValueChange = function(pnl, val)
        descTextValue = val

        isEdited = true
        saveButton:SetVisible(true)
    end

    local perkSettings = vgui.Create("DButton", clEditMenu)
    perkSettings:SetSize(clanSys.ScaleW(200), 50)
    perkSettings:SetPos(clEditMenu:GetWide() - 500, 465)
    perkSettings:SetText("")
    perkSettings.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Perk Setting", "Trebuchet24", w * 0.5, h * 0.5, pnl:IsHovered() and clanSys.MainColors.MainBlue or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    perkSettings.DoClick = function()
        clanSys.ClansPerkEditionMenu(parent, clan)
        clEditMenu:Remove()
    end 

    local memberSettings = vgui.Create("DButton", clEditMenu)
    memberSettings:SetSize(clanSys.ScaleW(200), 50)
    memberSettings:SetPos(clEditMenu:GetWide() - 200, 465)
    memberSettings:SetText("")
    memberSettings.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Members", "Trebuchet24", w * 0.5, h * 0.5, pnl:IsHovered() and clanSys.MainColors.MainBlue or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    memberSettings.DoClick = function()
        clanSys.ClanMembersEdit(parent, clan)
        clEditMenu:Remove()
    end 

    saveButton = vgui.Create("DButton", clEditMenu)
    saveButton:SetSize(200, 50)
    saveButton:SetPos(clEditMenu:GetWide() * 0.35, clEditMenu:GetTall() - 80)
    saveButton:SetVisible(false)
    saveButton:SetText("")
    saveButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(68, 68, 68))

        draw.SimpleText("Save", "Trebuchet24", w * 0.5, h * 0.5, Color( 70, 227, 56, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
end 