local clCreation

function clanSys.ClansCreateMenu(parent)
    if IsValid(clCreation) then clCreation:Remove() return end 

    clCreation = vgui.Create("DPanel", parent)
   -- clCreation:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    ---clCreation:SetPos(clanSys.ScaleW(225), 5)
    clCreation:Dock(FILL)
    clCreation:DockMargin(5, 5, 5, 5)
    clCreation.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, h - clanSys.ScaleH(150), w, clanSys.ScaleH(50), Color(135, 135, 135))
        draw.SimpleText("It cost " .. DarkRP.formatMoney(tonumber(clanSys.ClanPrice)) .. " to create a clan", "clanSys_trebuchet_24", w * 0.5, h - clanSys.ScaleH(125), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local blockBottom = vgui.Create("DPanel", clCreation)
    blockBottom:Dock(BOTTOM)
    blockBottom:SetTall(clanSys.ScaleH(80))
    blockBottom.Paint = function(pnl, w, h)
    end

    local blockLeft = vgui.Create("DPanel", clCreation)
    blockLeft:Dock(LEFT)
    blockLeft:SetWide(clanSys.ScaleW(500))
    blockLeft.Paint = function(pnl, w, h)
    end

    local blockRight = vgui.Create("DPanel", clCreation)
    blockRight:Dock(RIGHT)
    blockRight:SetWide(clanSys.ScaleW(500))
    blockRight.Paint = function(pnl, w, h)
    end

    local clanNamePanel = vgui.Create("DPanel", blockLeft)
    --clanNamePanel:SetSize(clanSys.ScaleW(300), 200)
    --clanNamePanel:SetPos(50, 25)
    clanNamePanel:Dock(TOP)
    --clanNamePanel:DockMargin(clanSys.ScaleW(50), clanSys.ScaleH(60), clanSys.ScaleW(650), clanSys.ScaleH(360))
    clanNamePanel:DockMargin(5, 15, 5, 5)
    clanNamePanel:SetTall(clanSys.ScaleH(125))
    clanNamePanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan Name", "clanSys_trebuchet_24", w * 0.5, h * 0.3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local clanName = ""
    local clanNameText = vgui.Create("DTextEntry", clanNamePanel)
    --clanNameText:SetSize(clanNamePanel:GetWide() - 10, 35)
    --clanNameText:SetPos(5, clanNamePanel:GetTall() * 0.5 + 15)
    clanNameText:Dock(BOTTOM)
    clanNameText:DockMargin(clanSys.ScaleW(100), 5, clanSys.ScaleW(100), 5)
    clanNameText:SetTall(clanSys.ScaleH(45))
    clanNameText:SetUpdateOnType(true)
    clanNameText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        local money = pnl:GetValue()
        draw.SimpleText(clanName, "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 
    clanNameText.OnValueChange = function(pnl, val)
        clanName = val
    end 
    clanNameText.OnEnter = function(pnl, val)
        clanName = val
    end

    local publicClanPanel = vgui.Create("DPanel", blockLeft)
    --publicClanPanel:SetSize(clanSys.ScaleW(300), 200)
    --publicClanPanel:SetPos(50, clCreation:GetTall() * 0.5)
    --publicClanPanel:Dock(FILL)
    --publicClanPanel:DockMargin(clanSys.ScaleW(50), clanSys.ScaleH(245), clanSys.ScaleW(650), clanSys.ScaleH(165))
    --publicClanPanel:DockPadding(clanSys.ScaleW(110), 5, clanSys.ScaleW(110), 5)
    publicClanPanel:Dock(BOTTOM)
    publicClanPanel:DockMargin(5, 5, 5, clanSys.ScaleH(175))
    publicClanPanel:SetTall(clanSys.ScaleH(125))
    publicClanPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Type(public/private)", "clanSys_trebuchet_24", w * 0.5, clanSys.ScaleH(10), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local typeClan = true
    local typeClanCheckBox = vgui.Create("clanSys_CheckBox", publicClanPanel)
    --typeClanCheckBox:SetSize(50, 50)
    --typeClanCheckBox:SetPos(publicClanPanel:GetWide() * 0.5 - 20, 25)
    typeClanCheckBox:Dock(FILL)
    typeClanCheckBox:DockMargin(clanSys.ScaleW(205), 5, clanSys.ScaleW(205), 5)
    typeClanCheckBox.OnChange = function(pnl, bool)
        typeClan = bool
    end   

    local clanTag = ""
    local clanTagPanel = vgui.Create("DPanel", blockRight)
    --clanTagPanel:SetSize(clanSys.ScaleW(300), 200)
    --clanTagPanel:SetPos(clCreation:GetWide() * 0.5 + 100, 25)
    clanTagPanel:Dock(TOP)
    clanTagPanel:DockMargin(5, 15, 5, 5)
    clanTagPanel:SetTall(clanSys.ScaleH(125))
    clanTagPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Clan Tag", "clanSys_trebuchet_24", w * 0.5, h * 0.3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if #clanTag >= 10 then 
            draw.SimpleText("The length of the tag mustn't be bigger then 10!", "clanSys_trebuchet_18", w * 0.5, h * 0.9, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local clanTagText = vgui.Create("DTextEntry", clanTagPanel)
    --clanTagText:SetSize(clanTagPanel:GetWide() - 10, 35)
    --clanTagText:SetPos(5, clanTagPanel:GetTall() * 0.5 + 15)
    clanTagText:Dock(BOTTOM)
    clanTagText:DockMargin(clanSys.ScaleW(100), 5, clanSys.ScaleW(100), 10)
    clanTagText:SetTall(clanSys.ScaleH(45))
    clanTagText:SetUpdateOnType(true)
    clanTagText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

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
    end 

    local imgurLink = ""
    local imgurLinkPanel = vgui.Create("DPanel", blockRight)
    --imgurLinkPanel:SetSize(clanSys.ScaleW(300), 200)
    --imgurLinkPanel:SetPos(clCreation:GetWide() * 0.5 + 100, clCreation:GetTall() * 0.5)
    --imgurLinkPanel:Dock(FILL)
    --imgurLinkPanel:DockMargin(clanSys.ScaleW(650), clanSys.ScaleH(245), clanSys.ScaleW(50), clanSys.ScaleH(165))
    imgurLinkPanel:Dock(BOTTOM)
    imgurLinkPanel:DockMargin(5, 5, 5, clanSys.ScaleH(175))
    imgurLinkPanel:SetTall(clanSys.ScaleH(125))
    imgurLinkPanel.Paint = function(pnl, w, h)
        draw.SimpleText("Imgur link", "clanSys_trebuchet_24", w * 0.5, h * 0.3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if imgurLink != "" and !string.find(imgurLink, "https://i.imgur.com/") then 
            draw.SimpleText("The link must be to imgur png!", "clanSys_trebuchet_18", w * 0.5, h * 0.9, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local imguLinkText = vgui.Create("DTextEntry", imgurLinkPanel)
    --imguLinkText:SetSize(imgurLinkPanel:GetWide() - 10, 35)
    --imguLinkText:SetPos(5, 25)
    imguLinkText:Dock(BOTTOM)
    imguLinkText:DockMargin(clanSys.ScaleW(100), 5, clanSys.ScaleW(100), 10)
    imguLinkText:SetTall(clanSys.ScaleH(45))
    imguLinkText:SetUpdateOnType(true)
    imguLinkText.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        local link = pnl:GetValue()
        draw.SimpleText(link, "clanSys_trebuchet_18", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
    end 
    imguLinkText.OnValueChange = function(pnl, val)
        imgurLink = val
    end       

    local createButtonContin = vgui.Create("DButton", blockBottom)
    --createButtonContin:SetSize(150, 40)
    --createButtonContin:SetPos(clCreation:GetWide() * 0.5 - 200, clCreation:GetTall() - 60)
    createButtonContin:Dock(LEFT)
    createButtonContin:DockMargin(clanSys.ScaleW(200), 5, clanSys.ScaleW(200), 5)
    createButtonContin:SetWide(clanSys.ScaleW(200))
    createButtonContin:SetText("")
    createButtonContin.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        draw.SimpleText("Create", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

        clCreation:Remove()
        clanSys.OpenMainMenu()
    end  

    local dismissButton = vgui.Create("DButton", blockBottom)
    --dismissButton:SetSize(150, 40)
    --dismissButton:SetPos(clCreation:GetWide() * 0.5 + 50, clCreation:GetTall() - 60)
    dismissButton:Dock(RIGHT)
    dismissButton:DockMargin(clanSys.ScaleW(200), 5, clanSys.ScaleW(200), 5)
    dismissButton:SetWide(clanSys.ScaleW(200))
    dismissButton:SetText("")
    dismissButton.Paint = function(pnl, w, h)
        draw.RoundedBox(20, 0, 0, w, h, Color(135, 135, 135))

        draw.SimpleText("Dismiss", "clanSys_trebuchet_24", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end   
    dismissButton.DoClick = function()
        clCreation:Remove()
        clanSys.ClansMenu(parent)

        activepanel = "Clans"
    end
end 