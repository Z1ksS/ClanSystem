local perksMenu

function clanSys.ClanPerksMenu(parent)
    if IsValid(perksMenu) then perksMenu:Remove() return end 

    perksMenu = vgui.Create("DPanel", parent)
    --perksMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    --perksMenu:SetPos(clanSys.ScaleW(225), 5)
    perksMenu:Dock(FILL)
    perksMenu:DockMargin(5, 5, 5, 5)
    perksMenu.Paint = function(pnl, w, h)
    end

    local value = 1
    for perk, perkProp in pairs(clanSys.ClanPerks) do 
        local perkPanel = vgui.Create("DPanel", perksMenu)
        --perkPanel:SetSize(perksMenu:GetWide() - 5, 100)
        --perkPanel:SetPos(0, 5 + (value - 1) * 120)
        perkPanel:Dock(TOP)
        perkPanel:DockMargin(5, 5, 5, 5)
        perkPanel:SetTall(clanSys.ScaleH(100))
        perkPanel.Paint = function(pnl, w, h)            
            local level = tonumber(clanSys.GetPlayerPerks(LocalPlayer():GetPlayerClan())[perk].level)

            if level >= #perkProp.tiers then 
                level = #perkProp.tiers
            else 
                level = level
            end 

            local money = 0

            if level >= #perkProp.tiers then 
                money = perkProp.tiers[level].price
            else 
                money = perkProp.tiers[level + 1].price
            end

            local needOrNo = level < #perkProp.tiers and " - " or ""
            draw.SimpleText(perkProp.namePerk .. " " .. clanSys.GetPlayerPerks(LocalPlayer():GetPlayerClan())[perk].level .. "/" .. #perkProp.tiers .. needOrNo, "clanSys_trebuchet_24", clanSys.ScaleW(20), clanSys.ScaleH(10), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            
            local xOffSet, yOffSet = surface.GetTextSize(perkProp.namePerk .. " " .. clanSys.GetPlayerPerks(LocalPlayer():GetPlayerClan())[perk].level .. "/" .. #perkProp.tiers .. " - ")
            draw.SimpleText(level < #perkProp.tiers and DarkRP.formatMoney(money) or "", "clanSys_trebuchet_24", clanSys.ScaleW(20) + xOffSet, clanSys.ScaleH(10), Color(70, 227, 56), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local bonus = ""
            
            if level >= #perkProp.tiers then  
               bonus = perkProp.tiers[level].bonus
            else 
                bonus = perkProp.tiers[level + 1].bonus
            end 
            
            if level < #perkProp.tiers then 
                if perk == "health" or perk == "armor" then 
                    bonus = "+" .. perkProp.tiers[level + 1].bonus
                elseif perk == "damagereduction" then 
                    bonus = "-" .. perkProp.tiers[level + 1].bonus .. "%"
                end
            elseif level >= #perkProp.tiers then 
                if perk == "health" or perk == "armor" then 
                    bonus = "+" .. perkProp.tiers[level].bonus
                elseif perk == "damagereduction" then 
                    bonus = "-" .. perkProp.tiers[level].bonus .. "%"
                end
            end 

            local xOffSetP, yOffSetP = surface.GetTextSize(bonus)
            draw.SimpleText(bonus, "clanSys_trebuchet_24", w - 50 - xOffSetP, clanSys.ScaleH(10), perkProp.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.RoundedBox(20, 0, clanSys.ScaleH(25), w - clanSys.ScaleW(45), h - clanSys.ScaleH(35), Color(90, 90, 90))

            for ind, tierProp in pairs(perkProp.tiers) do 
                if level + 1 >= ind + 1 then 
                    draw.RoundedBox(20, 5 + (ind - 1) * 95 * 0.9, clanSys.ScaleH(35), clanSys.ScaleW(95 * 0.9), h - clanSys.ScaleH(60), clanSys.MainColors.MainBlue)
                elseif level >= #perkProp.tiers then 
                    ind = #perkProp.tiers
                    draw.RoundedBox(20, 5 + (ind - 1) * clanSys.ScaleW(95) * 0.9, clanSys.ScaleH(35), clanSys.ScaleW(95) * 0.9, h - clanSys.ScaleH(60), clanSys.MainColors.MainBlue)
                elseif #perkProp.tiers >= 10 and ScrH() < 1080 then 
                    draw.RoundedBox(20, 5 + (ind - 1) * clanSys.ScaleW(95) * 0.8, clanSys.ScaleH(35), clanSys.ScaleW(95) * 0.9, h - clanSys.ScaleH(60), Color(135, 135, 135))
                else 
                    draw.RoundedBox(20, 5 + (ind - 1) * clanSys.ScaleW(95) * 0.9, clanSys.ScaleH(35), clanSys.ScaleW(95) * 0.9, h - clanSys.ScaleH(60), Color(135, 135, 135))
                end
            end
        end

        local upButtonLogo = Material("materials/clan_system/upgrade.png", "noclamp smooth")
        local upButton = vgui.Create("DButton", perkPanel)
        --upButton:SetSize(35, 35)
        --upButton:SetPos(perkPanel:GetWide() - 40, 40)
        upButton:Dock(RIGHT)
        upButton:DockMargin(5, clanSys.ScaleH(35), clanSys.ScaleW(10), clanSys.ScaleH(35))
        upButton:SetWide(clanSys.ScaleW(30))
        upButton:SetText("")
        upButton.Paint = function(pnl, w, h)
            if pnl:IsHovered() then
                draw.Material(0, 0, w, h, upButtonLogo, Color(133, 133, 133, 255))
            else 
                draw.Material(0, 0, w, h, upButtonLogo, Color(133, 133, 133, 155))
            end 
        end      
        upButton.DoClick = function()
            local clan = LocalPlayer():GetPlayerClan()

            if tonumber(clanSys.GetPlayerPerks(clan)[perk].level) >= #perkProp.tiers then Derma_Message("This perk has max level!", "Notice", "OK") return end

            local level = tonumber(clanSys.GetPlayerPerks(clan)[perk].level) + 1
            local pricePerk = perkProp.tiers[level].price
            
            if pricePerk > tonumber(clanSys.GetClanCurrency(clan)) then Derma_Message("There are no enough money in your clan storage!", "Notice", "OK") return end

            net.Start("ClanSysUpgradePerk")
                net.WriteEntity(LocalPlayer())
                net.WriteString(perk)
            net.SendToServer()

            perksMenu:Remove()
            clanSys.ClanPerksMenu(parent)
        end    

        value = value + 1
    end 
end 