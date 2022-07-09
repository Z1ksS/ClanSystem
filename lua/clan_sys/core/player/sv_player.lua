util.AddNetworkString("ClanSysSyncWithClient")

util.AddNetworkString("ClanSysInvitesSyncWithServer")
util.AddNetworkString("ClanSysInvitesSyncWithClient")

util.AddNetworkString("ClanSysSyncPaymentHistoryWithClient")
util.AddNetworkString("ClanSysPaymentSyncWithClient")

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

    if clanSys.Clans then 
        timer.Simple(1, function()
            if !ply:GetPlayerClan() then return end 
            for perk, perkProp in pairs(clanSys.GetPlayerPerks(ply:GetPlayerClan())) do 
                if perkProp.level > 0 and perkProp.enabled then 
                    clanSys.ClanPerks[perk].func(ply)
                end 
            end 
        end)
    end 
end )

net.Receive("ClanSysInvitesSyncWithServer", function()
    local data = net.ReadTable()
    local invated = net.ReadEntity()

    clanSys.Invites = data 

    for k, v in pairs(clanSys.Invites) do 
        if k != invated then return end 
         
        k:ChatPrint("You were invited in clan " .. v)
    end

    local dataToSend = util.TableToJSON(clanSys.Invites)

    local compressed_data = util.Compress( dataToSend )
    local bytes = #compressed_data

    net.Start("ClanSysInvitesSyncWithClient")
        net.WriteTable(clanSys.Invites)
    net.Broadcast()
end )

net.Receive("ClanSysSyncPaymentHistoryWithServer", function()
    local data = net.ReadTable()

    clanSys.ClanMoneyHistory = data 

    local dataToSend = util.JSONToTable(clanSys.ClanMoneyHistory)
    local compressed_data = util.Compress( dataToSend )
    local bytes = #compressed_data

    net.Start("ClanSysPaymentSyncWithClient")
        net.WriteUInt( bytes, 32 )
	    net.WriteData( compressed_data, bytes )
    net.Send(ply) 
end) 

hook.Add("PlayerDisconnected", "clanSysPlayerDisconnected", function(ply)
    if clanSys.Invites[ply] then 
        table.RemoveByValue(clanSys.Invites, clanSys.Invites[ply])
    end 
end )