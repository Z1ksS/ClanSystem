util.AddNetworkString("ClanSysSaveRanks")
util.AddNetworkString("ClanSysSendMoney")
util.AddNetworkString("ClanSysCreateRank")

util.AddNetworkString("ClanSysCreateClan")
util.AddNetworkString("ClanSysAcceptInvite")

util.AddNetworkString("ClanSysUpgradePerk")

util.AddNetworkString("ClanSysUpdateDatabase")

util.AddNetworkString("ClanSysKickPlayer")
util.AddNetworkString("ClanSysTransferClan")

util.AddNetworkString("ClanSysUpdateSettings")
util.AddNetworkString("ClanSysUpdateColor")


util.AddNetworkString("ClanSysSaveRanksNamePrior")
util.AddNetworkString("ClanSysDeleteRank")

util.AddNetworkString("ClanSysDisbandClan")

util.AddNetworkString("ClanSysLeaveClan")
util.AddNetworkString("ClanSysChangeRank")


function clanSys.CreateClan(name, logo, description, tag, public, color, owner)
    local wId = owner:SteamID()

    local members = {
        [tostring(wId)] = {
            rank = "owner"
        }
    }  

    local defaultPerks = {}

    for k, v in pairs(clanSys.ClanPerks) do 
        defaultPerks[k] = {
            name = v.namePerk,
            level = 0,
            enabled = true
        }
    end

    local logo_new = logo or "https://i.imgur.com/mYts9hj.png"
    local description_new = description or "Clan description"
    sql.Query("INSERT INTO clansys_clans(name, logo, description, tag, color, public, storage, owner, perks, ranks, members) VALUES(".. SQLStr(name) .. ", " .. SQLStr(logo_new) .. ", " .. SQLStr(description_new) .. ", " .. SQLStr(tag) .. ", " .. SQLStr(color) .. ", " .. SQLStr(public) .. ", " .. SQLStr(clanSys.defaultCurrency) .. ", " .. SQLStr(wId) .. ", " .. SQLStr(util.TableToJSON(defaultPerks)) .. ", " .. SQLStr(util.TableToJSON(clanSys.Ranks)) .. ", " .. SQLStr(util.TableToJSON(members)) .. ")")
    clanSys.UpdateTable()
end 

hook.Add("OnUpdatedRanks", "clanSysUpdatedRanks", function(newData, clan, ply, perm, rank, bool)
    sql.Query("UPDATE clansys_clans SET ranks = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(clanSys.GetClanId(clan)) .. ";")
    clanSys.UpdateTable()
end)

hook.Add("OnUpdatedRanksNamePrior", "clanSysOnUpdatedRanksNamePrior", function(newData, ply)
    local clan = ply:GetPlayerClan()
    
    sql.Query("UPDATE clansys_clans SET ranks = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(clanSys.GetClanId(clan)) .. ";")
    clanSys.UpdateTable()
end)

hook.Add("OnUpdatedStorageValue", "clanSysUpdatedStorageValue", function(clan, value, type, ply)
    sql.Query("UPDATE clansys_clans SET storage = " .. SQLStr(clanSys.GetClanCurrency(clan) + value) .. "WHERE id = " .. SQLStr(clanSys.GetClanId(clan)) .. ";")
    clanSys.UpdateTable()
end)

hook.Add("OnCreatedClan", "clanSysOnCreatedClan", function(name, tag, logo, typeClan, ply)
    local description = "This is default description for " .. name .. ". You can edit this in clan settings!"
    clanSys.CreateClan(name, logo, description, tag, typeClan, Color(255, 2, 5), ply)
end)

hook.Add("OnCreatedRank", "clanSysOnCreatedRank", function(ply)
    local ranksOld = clanSys.GetClanRanks(ply:GetPlayerClan())

    local rankNew = {
        ["new role"] = {
            name = "new role",
            perms = {
                ["description"] = false,
                ["kick"] = false, 
                ["upgrade"] = false,
                ["withdraw"] = false,
                ["deposit"] = false,
                ["invite"] = false,
                ["editgang"] = false,
                ["setgroup"] = false,
                ["creategroup"] = false,
                ["editgroups"] = false,
                ["disband"] = false
            },
            priority = 5
        }
    }
    local newRanks = table.Merge(ranksOld, rankNew)

    local newRanksToSet = util.TableToJSON(newRanks)
    local id = tonumber(clanSys.GetClanId(ply:GetPlayerClan()))

    sql.Query("UPDATE clansys_clans SET ranks = " .. SQLStr(newRanksToSet) .. "WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnJoinedClan", "clanSysOnJoinClan", function(ply, clan)
    local id = tonumber(clanSys.GetClanId(clan))
    local members = clanSys.GetClanPlayersTable(clan)
    
    local mId = ply:SteamID()
    local newMember = {
        [tostring(mId)] = {
            rank = "member"
        }
    }

    table.Merge(members, newMember)
    local newData = util.TableToJSON(members)
    
    sql.Query("UPDATE clansys_clans SET members = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(clanSys.GetClanId( clan ) ) .. ";")
    clanSys.UpdateTable()

    table.RemoveByValue(clanSys.Invites, ply)
end )

hook.Add("OnUpgradePerk", "clanSysOnUpgradePerk", function(ply, perk)
    local clan = ply:GetPlayerClan()
    local id = tonumber(clanSys.GetClanId(clan)) 

    local perks = clanSys.GetPlayerPerks(clan)

    perks[perk].level = perks[perk].level + 1
    
    local clanMoney = tonumber(clanSys.GetClanCurrency(clan))
    local price = clanSys.ClanPerks[perk].tiers[perks[perk].level].price
 
    if clanSys.ClanPerks[perk].tiers[perks[perk].level].price > clanMoney then return end 

    sql.Query("UPDATE clansys_clans SET storage = " .. SQLStr(clanSys.GetClanCurrency(clan) - price) .. "WHERE id = " .. SQLStr(id) .. ";")
    sql.Query("UPDATE clansys_clans SET perks = " .. SQLStr(util.TableToJSON(perks)) .. "WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnEditedPerk", "clanSysOnEditedPerk", function(ply, perk, status)
    local clan = ply:GetPlayerClan()
    local clanId = clanSys.GetClanId(clan)

    local oldPerks = clanSys.GetPlayerPerks(clan)

    oldPerks[perk].enabled = status 

    local newPerks = util.TableToJSON(oldPerks)
    sql.Query("UPDATE clansys_clans SET perks = " .. SQLStr(newPerks) .. "WHERE id = " .. SQLStr(clanId) .. ";")
    clanSys.UpdateTable()
end)

hook.Add("OnKickMember", "clanSysOnKickMember", function(ply, member)
    local oldMemberList = clanSys.GetClanPlayersTable(ply:GetPlayerClan())

    local clanIndex = clanSys.GetClanIndex(ply:GetPlayerClan())
    for ind, players in pairs(oldMemberList) do 
        if member == ind then 
            oldMemberList[member] = nil
        end 
    end 

    --[[net.Start("ClanSysSendChat")
	    net.WriteTable({Color(255, 255, 255), "clanSys", Color(50, 205, 50), ply:Nick(), ": ", Color(255, 255, 255), "you were kicked from clan " .. ply:GetPlayerClan()})
	net.Send(sendTo)--]]

    for k, v in pairs(player.GetAll()) do 
        if v:SteamID() == member then 
            local memb = player.GetBySteamID(member)
            memb:ChatPrint("You were kicked from clan " .. memb:GetPlayerClan())
        end 
    end 

    local newData = util.TableToJSON(oldMemberList)

    sql.Query("UPDATE clansys_clans SET members = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(clanSys.GetClanId(ply:GetPlayerClan()) ) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnTransferClan", "clanSysOnTransferClan", function(ply, member)
    local oldMemberList = clanSys.GetClanPlayersTable(ply:GetPlayerClan())

    local clanIndex = clanSys.GetClanIndex(ply:GetPlayerClan())
    for ind, players in pairs(oldMemberList) do 
        if member == ind then 
            oldMemberList[ply:SteamID()].rank = "member"
            oldMemberList[member].rank = "owner"
        end 
    end 

    --[[net.Start("ClanSysSendChat")
	    net.WriteTable({Color(255, 255, 255), "clanSys", Color(50, 205, 50), member:Nick(), ": ", Color(255, 255, 255), "you were signed as a knew owner of clan " .. member:GetPlayerClan()})
		net.WriteString(txt)
		net.WriteEntity(ply)
	net.Send(sendTo)--]]
    for k, v in pairs(player.GetAll()) do 
        if v:SteamID() == member then 
            local memb = player.GetBySteamID(member)
            memb:ChatPrint("You were signed as a knew owner of clan" .. memb:GetPlayerClan())
        end 
    end 

    ply:ChatPrint("You are now member of the " .. ply:GetPlayerClan())

    local newData = util.TableToJSON(oldMemberList)

    sql.Query("UPDATE clansys_clans SET members = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(clanSys.GetClanId(ply:GetPlayerClan()) ) .. ";")
    sql.Query("UPDATE clansys_clans SET owner = " .. SQLStr(member) .. "WHERE id = " .. SQLStr(clanSys.GetClanId(ply:GetPlayerClan()) ) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnSaveEditedSettings", "clanSysOnSaveEditedSettings", function(data, ply)
    local clanName = data.name
    local tag = data.tag 
    local logo = data.link 
    local typeClan = data.typeClan
    local description = data.description

    local editor = ply 

    local id = clanSys.GetClanId(editor:GetPlayerClan())
    sql.Query("UPDATE clansys_clans SET name = " .. SQLStr(clanName) .. "WHERE id = " .. SQLStr(id) .. ";")
    sql.Query("UPDATE clansys_clans SET tag = " .. SQLStr(tag) .. "WHERE id = " .. SQLStr(id) .. ";")
    sql.Query("UPDATE clansys_clans SET logo = " .. SQLStr(logo) .. "WHERE id = " .. SQLStr(id) .. ";")
    sql.Query("UPDATE clansys_clans SET public = " .. SQLStr(typeClan) .. "WHERE id = " .. SQLStr(id) .. ";")
    sql.Query("UPDATE clansys_clans SET description = " .. SQLStr(description) .. "WHERE id = " .. SQLStr(id) .. ";")

    clanSys.UpdateTable()
end )

hook.Add("OnDeleteRank", "clanSysOnDeleteRank", function(rank, ply)
    local clan = ply:GetPlayerClan()
    local id = clanSys.GetClanId(clan)
    local ranks = clanSys.GetClanRanks(clan)

    ranks[rank] = nil 

    local newData = util.TableToJSON(ranks)

    local MemberList = clanSys.GetClanPlayersTable(clan)

    for ind, players in pairs(MemberList) do 
        if players.rank == rank then 
            MemberList[ind].rank = "member"

            local newData = util.TableToJSON(MemberList)
            sql.Query("UPDATE clansys_clans SET members = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(id) .. ";")
        end 
    end 

    sql.Query("UPDATE clansys_clans SET ranks = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnDisbandClan", "clanSysOnDisbandClan", function(ply)
    local clan = ply:GetPlayerClan()
    local id = clanSys.GetClanId(clan)
    ply:ChatPrint("Your clan has been disband!")

    sql.Query("DELETE FROM clansys_clans WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnChangedClanColor", "clanSysOnChangedClanColor", function(ply, color)
    local clan = ply:GetPlayerClan()
    local id = clanSys.GetClanId(clan)

    local color = Color(color.r, color.g, color.b, color.a)

    sql.Query("UPDATE clansys_clans SET color = " .. SQLStr(color) .. "WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnPlayerLeave", "clanSysOnPlayerLeave", function(ply)
    local clan = ply:GetPlayerClan()
    local id = clanSys.GetClanId(clan)

    local oldMemberList = clanSys.GetClanPlayersTable(clan)

    for ind, players in pairs(oldMemberList) do 
        if ply:SteamID() == ind then 
            oldMemberList[ply:SteamID()] = nil 
        end 
    end 

    local newData = util.TableToJSON(oldMemberList)

    ply:ChatPrint("You have left clan " .. clan)

    sql.Query("UPDATE clansys_clans SET members = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnRankChanged", "clanSysOnRankChanged", function(ply, member, rank)
    local clan = ply:GetPlayerClan()
    local id = clanSys.GetClanId(clan)

    local oldMemberList = clanSys.GetClanPlayersTable(clan)

    for ind, players in pairs(oldMemberList) do 
        if member == ind then 
            oldMemberList[member].rank = rank 
        end 
    end 

    local newData = util.TableToJSON(oldMemberList)

    for k, v in pairs(player.GetAll()) do 
        if v:SteamID() == member then 
            local memb = player.GetBySteamID(member)
            memb:ChatPrint("You have been set to new rank: " .. rank)
        end 
    end 

    sql.Query("UPDATE clansys_clans SET members = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

net.Receive("ClanSysSaveRanks", function()
    local bytes = net.ReadUInt(32)
	local compressed_data = net.ReadData(bytes)
    local dataEdited = net.ReadTable()

    --if !dataEdited.editor:GetPlayerPermissions()[dataEdited.clan] then return end

	local data = util.Decompress(compressed_data)

    local newData = util.JSONToTable(data)

    local ranksOld = util.JSONToTable(clanSys.Clans[clanSys.GetClanIndex(dataEdited.clan)].ranks)
    ranksOld = util.TableToJSON(newData)

    --clanSys.UpdateRanks(ranksOld, dataEdited.clan, dataEdited.editor, dataEdited.perms, dataEdited.rank)

    hook.Run("OnUpdatedRanks", ranksOld, dataEdited.clan, dataEdited.editor, dataEdited.perms, dataEdited.rank)
end )

net.Receive("ClanSysSaveRanksNamePrior", function()
    local bytes = net.ReadUInt(32)
	local compressed_data = net.ReadData(bytes)
    local ply = net.ReadEntity()
    
	local data = util.Decompress(compressed_data)

    local ranksEdit = util.JSONToTable(data)

    local ranksOld = clanSys.GetClanRanks(ply:GetPlayerClan())

    for k, v in pairs(ranksEdit) do 
        if k == "new role" then 
            local newRole = {
                [string.lower(v.name)] = {
                    name = v.name, 
                    perms = v.perms, 
                    priority = v.priority
                }
            }
            table.Merge(ranksOld, newRole)
            ranksOld["new role"] = nil
        else 
            table.Merge(ranksOld, ranksEdit)
        end 
    end 

    local dataToSet = util.TableToJSON(ranksOld)

    hook.Run("OnUpdatedRanksNamePrior", dataToSet, ply)
end )

net.Receive("ClanSysSendMoney", function()
    local amount = net.ReadInt(32)
    local typeSend = net.ReadString()
    local ply = net.ReadEntity()
    local clan = net.ReadString()

    if !ply:IsValid() then return end 

    local val = typeSend == "withdraw" and amount or -amount
    ply:addMoney(val)  

    ply:ChatPrint(typeSend == "deposit" and "You have contributed $" .. amount .. " in " .. clan or "You have taken $" .. amount .. " from" .. clan .. " storage")

    local valSend = typeSend == "withdraw" and -amount or amount
    hook.Run("OnUpdatedStorageValue", clan, valSend, typeSend, ply)
end )

net.Receive("ClanSysCreateRank", function()
    local ply = net.ReadEntity()
    
    if !ply:IsValid() then return end 
    if ply:IsValid() and !ply:GetPlayerPermissions()["creategroup"] or !ply:GetPlayerPermissions()["editgroups"] then return end 

    hook.Run("OnCreatedRank", ply)
end )

net.Receive("ClanSysCreateClan", function()
    local data = net.ReadTable()

    if !data.ply:IsValid() then return end 

    data.ply:addMoney(-tonumber(clanSys.ClanPrice))
    data.ply:ChatPrint("You have created clan " .. data.name .. "!")

    hook.Run("OnCreatedClan", data.name, data.tag, data.link, data.typeClan, data.ply)
end )

net.Receive("ClanSysAcceptInvite", function()
    local clan = net.ReadString()
    local ply = net.ReadEntity()

    if !ply:IsValid() then return end 
    hook.Run("OnJoinedClan", ply, clan)
end )

net.Receive("ClanSysUpgradePerk", function()
    local ply = net.ReadEntity()
    local perk = net.ReadString()

    hook.Run("OnUpgradePerk", ply, perk)
end )

net.Receive("ClanSysUpdateDatabase", function()
    local bytes = net.ReadUInt(32)
	local compressed_data = net.ReadData(bytes)
    local ply = net.ReadEntity()

	local data = util.Decompress(compressed_data)

    local oldData = clanSys.GetPlayerPerks(ply:GetPlayerClan())
    local newData = util.JSONToTable(data)

    for k, v in pairs(oldData) do 
        for i, j in pairs(newData) do
            if k == i then 
                if v.enabled != j.enabled then
                    hook.Run("OnEditedPerk", ply, i, j.enabled)
                end 
            end 
        end
    end
end )

net.Receive("ClanSysKickPlayer", function()
    local data = net.ReadTable()

    local ply, member = data.editor, data.member

    if !ply:IsValid() then return end 

    hook.Run("OnKickMember", ply, member)
end )

net.Receive("ClanSysTransferClan", function()
    local data = net.ReadTable()

    local ply, member = data.owner, data.member

    if !ply:IsValid() then return end 

    hook.Run("OnTransferClan", ply, member)
end )

net.Receive("ClanSysUpdateSettings", function()
    local data = net.ReadTable()

    if !data.ply:IsValid() then return end 

    hook.Run("OnSaveEditedSettings", data, data.ply)
end )

net.Receive("ClanSysDeleteRank", function()
    local rank = net.ReadString()
    local ply = net.ReadEntity()

    hook.Run("OnDeleteRank", rank, ply)
end )

net.Receive("ClanSysDisbandClan", function()
    local ply = net.ReadEntity()

    hook.Run("OnDisbandClan", ply)
end )

net.Receive("ClanSysUpdateColor", function()
    local color = net.ReadTable()
    local ply = net.ReadEntity()

    hook.Run("OnChangedClanColor", ply, color)
end )

net.Receive("ClanSysDisbandClan", function()
    local ply = net.ReadEntity()

    if !ply:IsValid() then return end

    hook.Run("OnPlayerLeave", ply)
end )

net.Receive("ClanSysChangeRank", function()
    --local ply = net.ReadEntity()
    local data = net.ReadTable()
    local rank = net.ReadString()

    if !data.owner:IsValid() then return end
    
    hook.Run("OnRankChanged", data.owner, data.member, rank)
end )