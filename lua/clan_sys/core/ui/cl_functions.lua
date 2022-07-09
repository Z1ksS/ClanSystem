function clanSys.ScaleW(sizew)
	return sizew * (ScrW() / 1920)
end

function clanSys.ScaleH(sizeh)
	return sizeh * (ScrH() / 1080) 
end

surface.CreateFont("clanSys_trebuchet_18", {
	font = "Trebuchet", 
	extended = false,
	size = clanSys.ScaleH(18),
	weight = clanSys.ScaleW(18),
})

surface.CreateFont("clanSys_trebuchet_24", {
	font = "Trebuchet", 
	extended = false,
	size = clanSys.ScaleH(24),
	weight = clanSys.ScaleW(24),
})

function draw.Material( x, y, w, h, Mat, tblColor )
	surface.SetMaterial(Mat)
	surface.SetDrawColor(tblColor or Color(255,255,255,255))
	surface.DrawTexturedRect(x, y, w, h)
end

function draw.Arc( center, startang, endang, radius, roughness, thickness, color )
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	draw.NoTexture()
	local segs, p = roughness, {}
	for i2 = 0, segs do
		p[i2] = -i2 / segs * (math.pi/180) * endang - (startang/57.3)
	end
	for i2 = 1, segs do
		if endang <= 90 then
			segs = segs/2
		elseif endang <= 180 then
			segs = segs/4
		elseif endang <= 270 then
			segs = segs/6
		else
			segs = segs
		end
		local r1, r2 = radius, math.max(radius - thickness, 0)
		local v1, v2 = p[i2 - 1], p[i2]
		local c1, c2 = math.cos( v1 ), math.cos( v2 )
		local s1, s2 = math.sin( v1 ), math.sin( v2 )
		surface.DrawPoly{
			{ x = center.x + c1 * r2, y = center.y - s1 * r2 },
			{ x = center.x + c1 * r1, y = center.y - s1 * r1 },
			{ x = center.x + c2 * r1, y = center.y - s2 * r1 },
			{ x = center.x + c2 * r2, y = center.y - s2 * r2 },
		}
	end
end

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function textWrap(text, font, pxWidth)
	local total = 0

	surface.SetFont(font)

	local spaceSize = surface.GetTextSize(' ')
	text = text:gsub("(%s?[%S]+)", function(word)
			local char = string.sub(word, 1, 1)
			if char == "\n" or char == "\t" then
				total = 0
			end

			local wordlen = surface.GetTextSize(word)
			total = total + wordlen
			
			-- Wrap around when the max width is reached
			if wordlen >= pxWidth then -- Split the word if the word is too big
				local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
				total = splitPoint
				return splitWord
			elseif total < pxWidth then
				return word
			end

			-- Split before the word
			if char == ' ' then
				total = wordlen - spaceSize
				return '\n' .. string.sub(word, 2)
			end

			total = wordlen
			return '\n' .. word
		end)

	return text
end

function clanSys.CreateMaterialFromURL(url,name,parameters)
    http.Fetch(url, function(body)
        local material_path = "clansys_logos" .. "/" ..name.. ".png"

		if not file.Exists("clansys_logos","") then
        	file.CreateDir("clansys_logos")
    	end
        file.Write(material_path,body)

        local path = "data/" .. material_path

        local vmt = {
            ["$basetexture"] = path,
            ["$surfaceprop"] = "default",
            ["$model"] = 1,
  			["$translucent"] = 1,
  			["$vertexalpha"] = 1,
  			["$vertexcolor"] = 1
        }

        local material = CreateMaterial(name,"VertexLitGeneric",vmt)
        material:SetTexture("$basetexture",Material(path,"vertexlitgeneric"):GetName())
    end)
end
