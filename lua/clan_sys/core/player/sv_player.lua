util.AddNetworkString("ClanSysSyncWithClient")

util.AddNetworkString("ClanSysInvitesSyncWithServer")

function clanSys.SendToClient(ply)
    local dataToSend = clanSys.Clans and util.TableToJSON(clanSys.Clans) or util.TableToJSON({})

    local compressed_data = util.Compress( dataToSend )
    local bytes = #compressed_data

    net.Start("ClanSysSyncWithClient")
        net.WriteUInt( bytes, 32 )
	    net.WriteData( compressed_data, bytes )
    net.Send(ply) 
end 

hook.Add("PlayerSpawn", "clanSysPlayerSpawn", function(ply)
    clanSys.SendToClient(ply)

    timer.Simple(1, function()
        for perk, perkProp in pairs(clanSys.GetPlayerPerks(ply:GetPlayerClan())) do 
            if perkProp.level > 0 then 
                clanSys.ClanPerks[perk].func(ply)
            end 
        end 
    end)
end )

net.Receive("ClanSysInvitesSyncWithServer", function()
    local data = net.ReadTable()

    clanSys.Invites = data 
end )

hook.Add("PlayerDisconnected", "clanSysPlayerDisconnected", function(ply)
    if clanSys.Invites[ply] then 
        table.RemoveByValue(clanSys.Invites, clanSys.Invites[ply])
    end 
end )