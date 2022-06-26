function clanSys.GetClanPlayers(clan)
    if !clanSys.Clans then return 0 end

    local result = 0

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            local memb = util.JSONToTable(v.members)
            for i, j in pairs(memb) do
                result = result + 1
            end 
        end
    end 

    return result
end 

function clanSys.GetClanPlayersOnline(clan)
    if !clanSys.Clans then return 0 end

    local result = 0

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            local memb = util.JSONToTable(v.members)

            for i, j in pairs(memb) do
                for n, p in pairs(player.GetAll()) do 
                    if p:SteamID() == i then 
                        result = result + 1
                    end 
                end 
            end 
        end
    end 

    return result
end 

function clanSys.GetClanPlayersTable(clan)
    if !clanSys.Clans then return 0 end

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            local memb = util.JSONToTable(v.members)

            return memb
        end
    end 
end 

function clanSys.GetClanPlayersTableOnline(clan)
    if !clanSys.Clans then return 0 end

    local result = {}
    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            local memb = util.JSONToTable(v.members)

            for i, j in pairs(memb) do
                for n, p in pairs(player.GetAll()) do 
                    if p:SteamID() == i then 
                        table.insert(result, {ply = p})
                    end 
                end 
            end 
        end
    end 

    return result
end 

function clanSys.GetClanCurrency(clan)
    if !clanSys.Clans then return 0 end

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            return v.storage
        end
    end 
end 

function clanSys.GetClanColor(clan)
    if !clanSys.Clans then return 0 end

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            return string.ToColor(v.color)
        end
    end 
end 

function clanSys.GetClanLogo(clan)
    if !clanSys.Clans then return 0 end

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            if CLIENT then 
                if !file.Exists("data/clansys_logos/logo_" .. string.lower(v.tag), "DATA") then
                    clanSys.CreateMaterialFromURL(v.logo, "logo_" .. string.lower(v.tag))
                end 
                return "data/clansys_logos/logo_" .. string.lower(v.tag) .. ".png"
            end 
        end
    end 
end 

function clanSys.GetClanDescription(clan)
    if !clanSys.Clans then return 0 end

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            return v.description
        end
    end 
end 

function clanSys.GetClanRanks(clan)
    if !clanSys.Clans then return 0 end

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            return util.JSONToTable(v.ranks)
        end
    end 
end 

function clanSys.GetClanIndex(clan)
    if !clanSys.Clans then return 0 end

    for k, v in pairs(clanSys.Clans) do
        if v.name == clan then  
            return v.id
        end
    end 
end 