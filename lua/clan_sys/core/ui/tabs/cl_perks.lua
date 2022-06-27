local perksMenu

function clanSys.ClanPerksMenu(parent)
    if IsValid(perksMenu) then perksMenu:Remove() return end 

    perksMenu = vgui.Create("DPanel", parent)
    perksMenu:SetSize(clanSys.ScaleW(1000), clanSys.ScaleH(640))
    perksMenu:SetPos(225, 5)
    perksMenu.Paint = function(pnl, w, h)
    end

    local value = 1
    for perk, perkProp in pairs(clanSys.ClanPerks) do 
        local perkPanel = vgui.Create("DPanel", perksMenu)
        perkPanel:SetSize(perksMenu:GetWide() - 5, 100)
        perkPanel:SetPos(5, 5 + (value - 1) * 120)
        perkPanel.Paint = function(pnl, w, h)
            draw.SimpleText(perkProp.namePerk .. " " .. clanSys.GetPlayerPerks(LocalPlayer():GetPlayerClan())[perk].level .. "/" .. #perkProp.tiers .. " - ", "Trebuchet24", 20, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local level = tonumber(clanSys.GetPlayerPerks(LocalPlayer():GetPlayerClan())[perk].level) + 1
            local money = perkProp.tiers[level].price

            local xOffSet, yOffSet = surface.GetTextSize(perkProp.namePerk .. " " .. clanSys.GetPlayerPerks(LocalPlayer():GetPlayerClan())[perk].level .. "/" .. #perkProp.tiers .. " - ")
            draw.SimpleText(DarkRP.formatMoney(money), "Trebuchet24", 20 + xOffSet, 10, Color(70, 227, 56), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local bonus = perkProp.tiers[level].bonus
            if perk == "health" or perk == "armor" then 
                bonus = "+" .. perkProp.tiers[level].bonus
            end 

            local xOffSetP, yOffSetP = surface.GetTextSize(bonus)
            draw.SimpleText(bonus, "Trebuchet24", w - 30 - xOffSetP, 10, perkProp.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.RoundedBox(20, 0, 25, w - 25, h - 35, Color(90, 90, 90))

            for ind, tierProp in pairs(perkProp.tiers) do 
                draw.RoundedBox(20, 5 + (ind - 1) * 105, 35, 100, h - 55, Color(135, 135, 135))
            end
        end

        value = value + 1
    end 
end 