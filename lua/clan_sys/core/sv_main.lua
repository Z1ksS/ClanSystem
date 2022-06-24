util.AddNetworkString("ClanSysSaveRanks")
util.AddNetworkString("ClanSysSendMoney")

function clanSys.CreateClan(name, logo, description, tag, public, color, owner)
    local wId = owner:SteamID()

    local members = {
        [tostring(wId)] = {
            rank = "owner"
        }
    }  

    local logo_new = logo or "https://i.imgur.com/mYts9hj.png"
    local description_new = description or "Clan description"
    sql.Query("INSERT INTO clansys_clans(name, logo, description, tag, color, public, storage, owner, perks, ranks, members) VALUES(".. SQLStr(name) .. ", " .. SQLStr(logo_new) .. ", " .. SQLStr(description_new) .. ", " .. SQLStr(tag) .. ", " .. SQLStr(color) .. ", " .. SQLStr(public) .. ", " .. SQLStr(clanSys.defaultCurrency) .. ", " .. SQLStr(wId) .. ", " .. SQLStr(util.TableToJSON({})) .. ", " .. SQLStr(util.TableToJSON(clanSys.Ranks)) .. ", " .. SQLStr(util.TableToJSON(members)) .. ")")
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