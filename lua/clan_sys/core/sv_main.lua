util.AddNetworkString("ClanSysSaveRanks")
util.AddNetworkString("ClanSysSendMoney")
util.AddNetworkString("ClanSysCreateRank")

util.AddNetworkString("ClanSysCreateClan")
util.AddNetworkString("ClanSysAcceptInvite")


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
            level = 0
        }
    end

    local logo_new = logo or "https://i.imgur.com/mYts9hj.png"
    local description_new = description or "Clan description"
    sql.Query("INSERT INTO clansys_clans(name, logo, description, tag, color, public, storage, owner, perks, ranks, members) VALUES(".. SQLStr(name) .. ", " .. SQLStr(logo_new) .. ", " .. SQLStr(description_new) .. ", " .. SQLStr(tag) .. ", " .. SQLStr(color) .. ", " .. SQLStr(public) .. ", " .. SQLStr(clanSys.defaultCurrency) .. ", " .. SQLStr(wId) .. ", " .. SQLStr(util.TableToJSON(defaultPerks)) .. ", " .. SQLStr(util.TableToJSON(clanSys.Ranks)) .. ", " .. SQLStr(util.TableToJSON(members)) .. ")")
    clanSys.UpdateTable()
end 

hook.Add("OnUpdatedRanks", "clanSysUpdatedRanks", function(newData, clan, ply, perm, rank, bool)
    sql.Query("UPDATE clansys_clans SET ranks = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(clanSys.GetClanIndex(clan)) .. ";")
    clanSys.UpdateTable()
end)

hook.Add("OnUpdatedStorageValue", "clanSysUpdatedStorageValue", function(clan, value, type, ply)
    sql.Query("UPDATE clansys_clans SET storage = " .. SQLStr(clanSys.GetClanCurrency(clan) + value) .. "WHERE id = " .. SQLStr(clanSys.GetClanIndex(clan)) .. ";")
    clanSys.UpdateTable()
end)

hook.Add("OnCreatedClan", "clanSysOnCreatedClan", function(name, tag, logo, typeClan, ply)
    local description = "This is default description for " .. name .. ". You can edit this in clan settings!"
    clanSys.CreateClan(name, logo, description, tag, typeClan, Color(255, 2, 5), ply)
end)

hook.Add("OnCreatedRank", "clanSysOnCreatedRank", function(ply)
    local ranksOld = util.JSONToTable(clanSys.Clans[clanSys.GetClanIndex(ply:GetPlayerClan())].ranks)

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
    local id = tonumber(clanSys.GetClanIndex(ply:GetPlayerClan()))
    sql.Query("UPDATE clansys_clans SET ranks = " .. SQLStr(newRanksToSet) .. "WHERE id = " .. SQLStr(id) .. ";")
    clanSys.UpdateTable()
end )

hook.Add("OnJoinedClan", "clanSysOnJoinClan", function(ply, clan)
    local id = tonumber(clanSys.GetClanIndex(clan))
    local members = util.JSONToTable(clanSys.Clans[id].members)
    
    local mId = ply:SteamID()
    local newMember = {
        [tostring(mId)] = {
            rank = "member"
        }
    }

    table.Merge(members, newMember)
    local newData = util.TableToJSON(members)
    
    sql.Query("UPDATE clansys_clans SET members = " .. SQLStr(newData) .. "WHERE id = " .. SQLStr(clanSys.GetClanIndex( clan ) ) .. ";")
    clanSys.UpdateTable()

    table.RemoveByValue(clanSys.Invites, ply)
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

net.Receive("ClanSysSendMoney", function()
    local amount = net.ReadInt(32)
    local typeSend = net.ReadString()
    local ply = net.ReadEntity()

    if !ply:IsValid() then return end 

    local clan = ply:GetPlayerClan() 

    local val = typeSend == "withdraw" and amount or -amount
    ply:addMoney(val)  

    ply:ChatPrint(typeSend == "deposit" and "You have contributed $" .. amount .. " in your clan" or "You have taken $" .. amount .. " from your clan's storage")

    hook.Run("OnUpdatedStorageValue", clan, -val, typeSend, ply)
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