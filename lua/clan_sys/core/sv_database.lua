function clanSys.InitDataBase()
    sql.Query([[
        CREATE TABLE IF NOT EXISTS clansys_clans( 
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
            name VARCHAR(255),
            color VARCHAR(255),
            storage INTEGER,
            owner VARCHAR(32),
            perks TEXT,
            ranks TEXT,
            members TEXT
        )
    ]])

    local q = sql.Query("SELECT * FROM clansys_clans") 

    if istable(q) then 
        clanSys.Clans = q
    else 
        clanSys.clanSys = {}
    end
end 

hook.Add("Initialize", "ClanSysDataBaseInitialize", function()
    local q = sql.Query("SELECT * FROM clansys_clans") 

    if istable(q) then 
        clanSys.Clans = q
    else 
        clanSys.clanSys = {}
        clanSys.InitDataBase()
    end
end)