util.AddNetworkString("ClanSysSyncWithClient")

function clanSys.SendToClient(ply)
    local dataToSend = clanSys.Clans and util.TableToJSON(clanSys.Clans) or util.TableToJSON({})

    local compressed_data = util.Compress( dataToSend )
    local bytes = #compressed_data

    net.Start("ClanSysSyncWithClient")
        net.WriteUInt( bytes, 32 )
	    net.WriteData( compressed_data, bytes )
    net.Send(ply) 
end 

hook.Add("PlayerSpawn", "ClanSysPlayerSpawn", function(ply)
    clanSys.SendToClient(ply)
end )