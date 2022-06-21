function clanSys.UpdateTable()
    local q = sql.Query("SELECT * FROM clansys_clans") 

    if istable(q) then 
        clanSys.Clans = q
    else 
        clanSys.InitDataBase()
        clanSys.Clans = {}
    end
end 

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

    clanSys.UpdateTable()
end 

hook.Add("Initialize", "ClanSysDataBaseInitialize", function()
    clanSys.InitDataBase()
end)