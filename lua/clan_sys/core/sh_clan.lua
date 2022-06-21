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