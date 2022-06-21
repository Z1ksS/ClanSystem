net.Receive("ClanSysSyncWithClient", function(len, ply)
    local bytes = net.ReadUInt(32)
	local compressed_data = net.ReadData(bytes)
	local data = util.Decompress(compressed_data)

    clanSys.Clans = data or {}
end )