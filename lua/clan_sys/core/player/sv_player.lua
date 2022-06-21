util.AddNetworkString("ClanSysSyncWithClient")

hook.Add("PlayerSpawn", "ClanSysPlayerSpawn", function(ply)
    local dataToSend = clanSys.Clans

    local compressed_data = util.Compress( dataToSend )
    local bytes = #compressed_data

    net.Start("ClanSysSyncWithClient")
        net.WriteUInt( bytes, 32 )
	    net.WriteData( compressed_data, bytes )
    net.Send(ply) 
end )