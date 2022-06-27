local pMeta = FindMetaTable("Player")

function pMeta:GetPlayerClan()
    if !clanSys.Clans then return nil end 

    for k, v in pairs(clanSys.Clans) do 
        local memb = util.JSONToTable(v.members)

        if memb[self:SteamID()] then 
            return v.name 
        else 
            return nil
        end 
    end
end 

function pMeta:GetPlayerClanRank()
    if !clanSys.Clans then return nil end 

    for k, v in pairs(clanSys.Clans) do 
        local memb = util.JSONToTable(v.members)

        if memb[self:SteamID()] then 
            return memb[self:SteamID()].rank
        else 
            return nil
        end 
    end
end 

function pMeta:GetPlayerPermissions()
    if !clanSys.Clans then return nil end 

    for k, v in pairs(clanSys.Clans) do 
        local memb = util.JSONToTable(v.members)
        local ranks = util.JSONToTable(v.ranks)

        if memb[self:SteamID()] then 
            return ranks[self:GetPlayerClanRank()].perms
        else 
            return nil
        end 
    end
end 

function pMeta:GetPlayerRankPriority()
    if !clanSys.Clans then return nil end 

    for k, v in pairs(clanSys.Clans) do 
        local memb = util.JSONToTable(v.members)
        local ranks = util.JSONToTable(v.ranks)

        if memb[self:SteamID()] then 
            return ranks[self:GetPlayerClanRank()].priority
        else 
            return nil
        end 
    end
end 