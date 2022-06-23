function clanSys.CreateClan(name, logo, description, tag, color, owner)
    local wId = owner:SteamID()

    local members = {
        [tostring(wId)] = {
            rank = "owner"
        }
    }  

    local logo_new = logo or "https://i.imgur.com/mYts9hj.png"
    local description_new = description or "Clan description"
    sql.Query("INSERT INTO clansys_clans(name, logo, description, tag, color, storage, owner, perks, ranks, members) VALUES(".. SQLStr(name) .. ", " .. SQLStr(logo_new) .. ", " .. SQLStr(description_new) .. ", " .. SQLStr(tag) .. ", " .. SQLStr(color) .. ", " .. SQLStr(clanSys.defaultCurrency) .. ", " .. SQLStr(wId) .. ", " .. SQLStr(util.TableToJSON({})) .. ", " .. SQLStr(util.TableToJSON(clanSys.Ranks)) .. ", " .. SQLStr(util.TableToJSON(members)) .. ")")
    clanSys.UpdateTable()
end 