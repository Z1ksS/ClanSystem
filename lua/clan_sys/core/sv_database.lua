function clanSys.UpdateTable()
    local q = sql.Query("SELECT * FROM clansys_clans") 

    if istable(q) then 
        clanSys.Clans = q
    else 
        clanSys.Clans = {}
    end

    for k, v in pairs(player.GetAll()) do 
        clanSys.SendToClient(v)
    end
end 

function clanSys.InitDataBase()
    sql.Query([[
        CREATE TABLE IF NOT EXISTS clansys_clans( 
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
            name VARCHAR(255),
            logo VARCHAR(200),
            description VARCHAR(255),
            tag VARCHAR(10),
            color VARCHAR(255),
            storage INTEGER,
            owner VARCHAR(32),
            perks TEXT,
            ranks TEXT,
            members TEXT
        )
    ]])

    clanSys.UpdateTable()
end 

hook.Add("Initialize", "ClanSysDataBaseInitialize", function()
    clanSys.InitDataBase()
end)