function clanSys.CreateClan(name, color, owner)
    local q = sql.Query("SELECT * FROM clansys_clans") 

    if istable(q) then 
        local wId = owner:SteamID64()

        local members = {
            [tostring(wId)] = {
                rank = "owner"
            }
        }
        sql.Query("INSERT INTO clansys_clans(name, color, storage, owner, perks, ranks, members) VALUES(".. SQLStr(name) .. ", " .. SQLStr(color) .. ", " .. SQLStr(clanSys.defaultCurrency) .. ", " .. SQLStr(wId) .. ", " .. SQLStr(util.TableToJSON({})) .. ", " .. SQLStr(util.TableToJSON(clanSys.Ranks)) .. ", " .. SQLStr(util.TableToJSON(members)) .. ")")
    else 
        clanSys.InitDataBase()

        local wId = owner:SteamID64()

        local members = {
            [tostring(wId)] = {
                rank = "owner"
            }
        }
        sql.Query("INSERT INTO clansys_clans(name, color, storage, owner, perks, ranks, members) VALUES(".. SQLStr(name) .. ", " .. SQLStr(color) .. ", " .. SQLStr(clanSys.defaultCurrency) .. ", " .. SQLStr(wId) .. ", " .. SQLStr(util.TableToJSON({})) .. ", " .. SQLStr(util.TableToJSON(clanSys.Ranks)) .. ", " .. SQLStr(util.TableToJSON(members)) .. ")")
    end 
end 