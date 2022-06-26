net.Receive("ClanSysSyncWithClient", function(len, ply)
    local bytes = net.ReadUInt(32)
	local compressed_data = net.ReadData(bytes)
    local ply = net.ReadEntity()

	local data = util.Decompress(compressed_data)

    clanSys.Clans = util.JSONToTable(data) or {}
    clanSys.Messages = {}
    clanSys.Invites = {}
    if clanSys.Clans then 
        for k, v in pairs(clanSys.Clans) do 
            clanSys.Messages[v.name] = {}
        end
    end 
end )