clanSys.MainColors = clanSys.MainColors or {}

clanSys.MainColors = {
    MainBlue = Color(0, 55, 255),
    MainGrey = Color(50, 50, 50),
    SecondaryGrey = Color(60, 60, 60)
}

clanSys.defaultCurrency = 5000

clanSys.Ranks = {
    ["owner"] = {
        name = "Owner",
        perms = {
            ["kick"] = true, 
            ["upgrade"] = true,
            ["withdraw"] = true,
            ["deposit"] = true,
            ["invite"] = true,
            ["editgang"] = true,
            ["setgroup"] = true,
            ["creategroup"] = true,
            ["editgroups"] = true,
            ["disband"] = true
        }
    },
    ["member"] = {
        name = "Member",
        perms = {
            ["kick"] = false, 
            ["upgrade"] = false,
            ["withdraw"] = false,
            ["deposit"] = true,
            ["invite"] = false,
            ["editgang"] = false,
            ["setgroup"] = false,
            ["creategroup"] = false,
            ["editgroups"] = false,
            ["disband"] = false
        }
    }
}

clanSys.ChatCommand = "c" --chat prefix for sending messages in clan chat, so you can use !c or /c
clanSys.MenuCommand = "clan" --chat prefix for opening clan menu
