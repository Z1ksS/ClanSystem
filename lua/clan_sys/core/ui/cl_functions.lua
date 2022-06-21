function clanSys.ScaleW(sizew)
	return ScrW() * ( sizew / 1920 )
end

function clanSys.ScaleH(sizeh)
	return ScrH() * (sizeh / 1080) 
end

function draw.Material( x, y, w, h, Mat, tblColor )
	surface.SetMaterial(Mat)
	surface.SetDrawColor(tblColor or Color(255,255,255,255))
	surface.DrawTexturedRect(x, y, w, h)
end