function clanSys.CreateClan(name, color, owner)
    local wId = owner:SteamID()

    local members = {
        [tostring(wId)] = {
            rank = "owner"
        }
    }
    sql.Query("INSERT INTO clansys_clans(name, color, storage, owner, perks, ranks, members) VALUES(".. SQLStr(name) .. ", " .. SQLStr(color) .. ", " .. SQLStr(clanSys.defaultCurrency) .. ", " .. SQLStr(wId) .. ", " .. SQLStr(util.TableToJSON({})) .. ", " .. SQLStr(util.TableToJSON(clanSys.Ranks)) .. ", " .. SQLStr(util.TableToJSON(members)) .. ")")
    clanSys.UpdateTable()
end 