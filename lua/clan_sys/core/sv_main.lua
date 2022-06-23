util.AddNetworkString("ClanSysSaveRanks")

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

net.Receive("ClanSysSaveRanks", function()
    local bytes = net.ReadUInt(32)
	local compressed_data = net.ReadData(bytes)
    local clan = net.ReadString()

	local data = util.Decompress(compressed_data)

    local new_data = util.JSONToTable(data)

    local ranksOld = util.JSONToTable(clanSys.Clans[clanSys.GetClanIndex(clan)].ranks)
    ranksOld = util.TableToJSON(new_data)

    sql.Query("UPDATE clansys_clans SET ranks = " .. SQLStr(ranksOld) .. "WHERE id = " .. SQLStr(clanSys.GetClanIndex(clan)) .. ";")
    print(sql.LastError())
    clanSys.UpdateTable()
end )