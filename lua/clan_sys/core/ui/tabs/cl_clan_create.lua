local clCreation

function clanSys.ClansCreateMenu(parent)
    if IsValid(clCreation) then clCreation:Remove() return end 

    clCreation = vgui.Create("DPanel", parent)
    clCreation:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    clCreation:SetPos(225, 5)
    clCreation.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, h - 150, w, 50, Color(135, 135, 135))
        draw.SimpleText("It cost " .. DarkRP.formatMoney(tonumber(clanSys.ClanPrice)) .. " to create a clan", "Trebuchet24", w * 0.5, h - 125, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local clanNamePanel = vgui.Create("DPanel", clCreation)
    clanNamePanel:SetSize(300, 200)
    clanNamePanel:SetPos(50, 25)
    clanNamePanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan Name", "Trebuchet24", w * 0.5, h * 0.45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local clanName = ""
    local clanNameText = vgui.Create("DTextEntry", clanNamePanel)
    clanNameText:SetSize(clanNamePanel:GetWide() - 10, 35)
    clanNameText:SetPos(5, clanNamePanel:GetTall() * 0.5 + 15)
    clanNameText:SetUpdateOnType(true)
    clanNameText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        local money = pnl:GetValue()
        draw.SimpleText(clanName, "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    clanNameText.OnValueChange = function(pnl, val)
        clanName = val
    end 
    clanNameText.OnEnter = function(pnl, val)
        clanName = val
    end  

    local clanTag = ""
    local clanTagPanel = vgui.Create("DPanel", clCreation)
    clanTagPanel:SetSize(300, 200)
    clanTagPanel:SetPos(clCreation:GetWide() * 0.5 + 100, 25)
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
    clanTagText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

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
    end 

    local publicClanPanel = vgui.Create("DPanel", clCreation)
    publicClanPanel:SetSize(300, 200)
    publicClanPanel:SetPos(50, clCreation:GetTall() * 0.5)
    publicClanPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan type(public/private)", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local typeClan = true
    local typeClanCheckBox = vgui.Create("clanSys_CheckBox", publicClanPanel)
    typeClanCheckBox:SetSize(50, 50)
    typeClanCheckBox:SetPos(publicClanPanel:GetWide() * 0.5 - 20, 25)
    typeClanCheckBox.OnChange = function(pnl, bool)
        typeClan = bool
    end   

    local imgurLink = ""
    local imgurLinkPanel = vgui.Create("DPanel", clCreation)
    imgurLinkPanel:SetSize(300, 200)
    imgurLinkPanel:SetPos(clCreation:GetWide() * 0.5 + 100, clCreation:GetTall() * 0.5)
    imgurLinkPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Imgur link", "Trebuchet24", w * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if imgurLink != "" and !string.find(imgurLink, "https://i.imgur.com/") then 
            draw.SimpleText("The link must be to imgur png!", "Trebuchet18", w * 0.5, h * 0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local imguLinkText = vgui.Create("DTextEntry", imgurLinkPanel)
    imguLinkText:SetSize(imgurLinkPanel:GetWide() - 10, 35)
    imguLinkText:SetPos(5, 25)
    imguLinkText:SetUpdateOnType(true)
    imguLinkText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        local link = pnl:GetValue()
        draw.SimpleText(link, "Trebuchet18", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
    end 
    imguLinkText.OnValueChange = function(pnl, val)
        imgurLink = val
    end       

    local createButtonContin = vgui.Create("DButton", clCreation)
    createButtonContin:SetSize(150, 40)
    createButtonContin:SetPos(clCreation:GetWide() * 0.5 - 200, clCreation:GetTall() - 60)
    createButtonContin:SetText("")
    createButtonContin.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        draw.SimpleText("Create", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end   
    createButtonContin.DoClick = function()
        if LocalPlayer():GetPlayerClan() then Derma_Message("You are currently in a clan! Leave or disband your current clan, to create your own!", "Notice", "OK") return end
        if clanName == "" or clanTag == "" or imgurLink == "" or imgurLink != "" and !string.find(imgurLink, "https://i.imgur.com/") or clanTag != "" and #clanTag > 10 then Derma_Message("There are errors in text the fields! Check and fix them!", "Notice", "OK") return end

        if tonumber(clanSys.ClanPrice) > LocalPlayer():getDarkRPVar("money") then Derma_Message("You don't have enought money to create clan!", "Notice", "OK") return end
        
        local tblToSend = {
            name = clanName,
            tag = clanTag, 
            link = imgurLink,
            typeClan = typeClan,
            ply = LocalPlayer()
        }

        net.Start("ClanSysCreateClan")
            net.WriteTable(tblToSend)
        net.SendToServer()

        parent:GetParent():Remove()
        clanSys.OpenMainMenu()
    end  

    local dismissButton = vgui.Create("DButton", clCreation)
    dismissButton:SetSize(150, 40)
    dismissButton:SetPos(clCreation:GetWide() * 0.5 + 50, clCreation:GetTall() - 60)
    dismissButton:SetText("")
    dismissButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        draw.SimpleText("Dismiss", "Trebuchet24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end   
    dismissButton.DoClick = function()
        clCreation:Remove()
        clanSys.ClansMenu(parent)
    end    
end 