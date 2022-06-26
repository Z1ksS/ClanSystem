local PANELAvatar = {}

function PANELAvatar:Init()
    self.base = vgui.Create("AvatarImage", self)
    self.base:Dock(FILL)
    self.base:SetPaintedManually(true)
end

function PANELAvatar:GetBase()
    return self.base
end

function PANELAvatar:PushMask(mask)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    mask()

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
end

function PANELAvatar:PopMask()
    render.SetStencilEnable(false)
    render.ClearStencil()
end

function PANELAvatar:Paint(w, h)
    self:PushMask(function()
        local poly = {}

        local x, y = w / 2, h / 2
        for angle = 1, 360 do
            local rad = math.rad(angle)

            local cos = math.cos(rad) * y
            local sin = math.sin(rad) * y

            poly[#poly + 1] = {
                x = x + cos,
                y = y + sin
            }
        end

        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawPoly(poly)
    end)

    self.base:PaintManual()
    self:PopMask()
end

vgui.Register("CircularAvatar", PANELAvatar)

local PANELLogo = {}

function PANELLogo:Init()
    self.base = vgui.Create("DImage", self)
    self.base:Dock(FILL)
    self.base:SetPaintedManually(true)
end

function PANELLogo:GetBase()
    return self.base
end

function PANELLogo:PushMask(mask)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    mask()

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
end

function PANELLogo:PopMask()
    render.SetStencilEnable(false)
    render.ClearStencil()
end

function PANELLogo:Paint(w, h)
    self:PushMask(function()
        local poly = {}

        local x, y = w / 2, h / 2
        for angle = 1, 360 do
            local rad = math.rad(angle)

            local cos = math.cos(rad) * y
            local sin = math.sin(rad) * y

            poly[#poly + 1] = {
                x = x + cos,
                y = y + sin
            }
        end

        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawPoly(poly)
    end)

    self.base:PaintManual()
    self:PopMask()
end

function PANELLogo:SetImage(img)
    self.base:SetImage(img)
end 

vgui.Register("CircularLogo", PANELLogo)


local PANEL = {}

function PANEL:Paint(w, h)
    draw.RoundedBox(9, 0, 0, w, h, Color(90, 90, 90))
    
    draw.SimpleText(self.Player:Name(), "Trebuchet24", 85, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.Player:GetPlayerClanRank(), "Trebuchet18", 85, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end 

function PANEL:SetPlayer(ply)
    self.Player = ply 

    self.Avatar = vgui.Create("CircularAvatar", self)
    self.Avatar:SetPos(5, 5)
    self.Avatar:SetSize(50, 50)
    self.Avatar:GetBase():SetPlayer(self.Player, 64)
end 

vgui.Register("clanSys_PlayerProfile", PANEL, "DPanel")