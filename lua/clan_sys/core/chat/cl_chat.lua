function clanSys.StoreMessages(msg, ply)
    if clanSys.Messages[ply:GetPlayerClan()] then  
        table.insert(clanSys.Messages[ply:GetPlayerClan()], {message = msg, sender = ply})
    end 
end 

net.Receive("ClanSysSendChat", function(len, ply)
    local msg = net.ReadTable()
    chat.AddText(unpack(msg))

    clanSys.StoreMessages(net.ReadString(), net.ReadEntity())
end)