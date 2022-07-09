util.AddNetworkString("ClanSysSendChat")
util.AddNetworkString("ClanSysSendChatServer")

util.AddNetworkString("ClanSysOpenMenu")

local function sendChat(ply, txt)
	local sendTo = {}

	local clan = ply:GetPlayerClan()
	for _, onlinePlayer in ipairs(player.GetAll()) do
		if clanSys.GetClanPlayersTable(clan)[onlinePlayer:SteamID()] then
			table.insert(sendTo, onlinePlayer)
		end
	end

	local color = Color(clanSys.GetClanColor(clan).r, clanSys.GetClanColor(clan).g, clanSys.GetClanColor(clan).b, clanSys.GetClanColor(clan).a)

	net.Start("ClanSysSendChat")
	    net.WriteTable({color, "[" .. clan .. "] ", Color(50, 205, 50), ply:Nick(), ": ", Color(255, 255, 255), txt})
		net.WriteString(txt)
		net.WriteEntity(ply)
	net.Send(sendTo)			
end

net.Receive("ClanSysSendChatServer", function(len, ply)
	sendChat(ply, net.ReadString())
end )

hook.Add("PlayerSay", "ClanSysPlayerSay", function(ply, text)
	if (string.StartWith(string.lower(text), string.lower("/" .. clanSys.ChatCommand) .. " ") or (string.StartWith(string.lower(text), string.lower("!" .. clanSys.ChatCommand) .. " ") ) or string.lower(text) == string.lower(clanSys.ChatCommand)) and !ply:GetPlayerClan() then ply:ChatPrint("You are not in clan!") end 
	
    if (string.StartWith(string.lower(text), string.lower("/" .. clanSys.ChatCommand) .. " ") or (string.StartWith(string.lower(text), string.lower("!" .. clanSys.ChatCommand) .. " ") ) or string.lower(text) == string.lower(clanSys.ChatCommand)) then 
		text = string.Trim(string.sub(text, string.len(clanSys.ChatCommand) + 2))
		if text != "" then sendChat(ply, text) end
		return ""
	end

	if string.StartWith(string.lower(text), string.lower("/" .. clanSys.MenuCommand)) or string.StartWith(string.lower(text), string.lower("!" .. clanSys.MenuCommand)) then 
		net.Start("ClanSysOpenMenu")
		net.Send(ply)
	end
end )