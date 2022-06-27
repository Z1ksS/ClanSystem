clanSys.MainColors = clanSys.MainColors or {}

clanSys.MainColors = {
    MainBlue = Color(0, 55, 255),
    MainGrey = Color(50, 50, 50),
    SecondaryGrey = Color(60, 60, 60)
}

clanSys.defaultCurrency = 5000

clanSys.Ranks = {
    ["owner"] = { --don't edit this, because it is basic for all system
        name = "Owner", --name of the group
        perms = { --group flags(permissions)
            ["description"] = true,
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
        },
        priority = 1 --rank priority, so 1 priority means that it can't be edited by anyone else beside this group
    },
    ["member"] = {
        name = "Member",
        perms = {
            ["description"] = true,
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
        },
        priority = 5
    }
}

clanSys.ClanPerks = {
    ["health"] = {
        namePerk = "Health",
        color = Color(255, 0, 0),
        func = function(ply) 
            local level = clanSys.GetPlayerPerks(ply:GetPlayerClan())["health"].level
            --if level <= 0 then return end 

            if SERVER then
                ply:SetHealth(ply:Health() + clanSys.ClanPerks["health"].tiers[level].bonus) 
            end
        end,
        tiers = {
            [1] = {
                price = 450000,
                bonus = 2,
            },
            [2] = {
                price = 500000,
                bonus = 5,
            },
            [3] = {
                price = 650000,
                bonus = 10,
            },
            [4] = {
                price = 700000,
                bonus = 15,
            }
        }
    },
    ["armor"] = {
        namePerk = "Armor",
        color = Color(0, 0, 255),
        func = function(ply) 
            local level = clanSys.GetPlayerPerks(ply:GetPlayerClan())["armor"].level
            --if level <= 0 then return end

            if SERVER then 
                ply:SetArmor(ply:Armor() + clanSys.ClanPerks["armor"].tiers[level].bonus) 
            end 
        end,
        tiers = {
            [1] = {
                price = 450000,
                bonus = 3,
            },
            [2] = {
                price = 500000,
                bonus = 5,
            },
            [3] = {
                price = 850000,
                bonus = 15,
            }
        }
    },
    ["permaweapon"] = {
        namePerk = "Perma Weapon",
        color = Color(255, 255, 255),
        func = function(ply) 
            local level = clanSys.GetPlayerPerks(ply:GetPlayerClan())["permaweapon"].level
            --if level <= 0 then return end

            if SERVER then  
                ply:Give(clanSys.ClanPerks["permaweapon"].tiers[level].bonus) 
            end
        end,
        tiers = {
            [1] = {
                price = 500000,
                bonus = "weapon_ak472",
            },
            [2] = {
                price = 1000000,
                bonus = "weapon_m42",
            }
        }
    },
    ["damagereduction"] = {
        namePerk = "Clan Damage Reduction",
        color = Color(255, 255, 255),
        func = function(ply) 
            if SERVER then 
                local level = clanSys.GetPlayerPerks(ply:GetPlayerClan())["damagereduction"].level

                hook.Add("EntityTakeDamage", "clanSysReduceDamage", function( target, dmginfo )
                    if ( target:IsPlayer() and target:GetPlayerClan()  ) then 
                        dmginfo:SetDamage(dmginfo:GetDamage() * (clanSys.ClanPerks["damagereduction"].tiers[level].bonus / 100 ))
                    end
                end )
            end 
        end,
        tiers = {
            [1] = {
                price = 500000,
                bonus = 10,
            },
            [2] = {
                price = 1000000,
                bonus = 20,
            },
            [3] = {
                price = 1350000,
                bonus = 25,
            },
            [4] = {
                price = 1500000,
                bonus = 30,
            },
            [5] = {
                price = 1750000,
                bonus = 35,
            },
            [6] = {
                price = 1950000,
                bonus = 40,
            },
            [7] = {
                price = 2250000,
                bonus = 45,
            },
            [8] = {
                price = 2450000,
                bonus = 50,
            },
            [9] = {
                price = 2550000,
                bonus = 55,
            },
            [10] = {
                price = 2750000,
                bonus = 60,
            }
        }
    }
}

clanSys.ChatCommand = "c" --chat prefix for sending messages in clan chat, so you can use !c or /c
clanSys.MenuCommand = "clan" --chat prefix for opening clan menu

clanSys.ClanPrice = "1000000" --price to create clan