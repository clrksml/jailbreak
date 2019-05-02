local PANEL = {}

function PANEL:Init()
	self:SetZPos(-99999)
	self:SetPos(-20, -20)
	self:SetSize(ScrW() + 40, ScrH() + 40)
	self.Paint = function(_, w, h)
		if LocalPlayer():IsInmate() then
			surface.DrawImage(w / 2 - 256, h / 2 - 256, 512,  512, "icons/cell.png")
		end
		if LocalPlayer():IsGuard() then
			surface.DrawImage(w / 2 - 256, h / 2 - 256, 512,  512, "icons/prison.png")
		end
	end

	self.Refresh = function()
		surface.SetFont(self:GetFont())

		local w, h = surface.GetTextSize(self:GetText())
		local color, font, text = self:GetColor(), self:GetFont(), self:GetText()

		local DPanel = vgui.Create("DPanel", self)
		DPanel:SetPos(self:GetWide() + (w + 1), (ScrH() / 2) - (ScrH() / 2))
		DPanel:SetSize(w, h)
		DPanel.Paint = function(self, width, height)
			surface.DrawSentence(font, Color(0, 0, 0), -1, 1, text)
			surface.DrawSentence(font, Color(0, 0, 0), 1, -1, text)
			surface.DrawSentence(font, color, 0, 0, text)
		end

		if self:GetPlane() == "x" then
			if self:IsInverted() then
				DPanel:SetPos(ScrW() + (w + 1), (ScrH() / 2) - (h / 2))

				if self:GetHalfway() then
					DPanel:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				else
					DPanel:MoveTo(-w, (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				end
			else
				DPanel:SetPos(-w, (ScrH() / 2) - (h / 2))

				if self:GetHalfway() then
					DPanel:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				else
					DPanel:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				end
			end
		else
			if self:IsInverted() then
				DPanel:SetPos((ScrW() / 2) - (w / 2), ScrH() + (h + 1))

				if self:GetHalfway() then
					DPanel:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				else
					DPanel:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				end
			else
				DPanel:SetPos((ScrW() / 2) - (w / 2), -h)

				if self:GetHalfway() then
					DPanel:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				else
					DPanel:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), 2, 0, 1, function() self:Remove() end)
				end
			end
		end
	end
end

function PANEL:SetPlane( str )
	self.plane = str
end

function PANEL:GetPlane()
	return self.plane or "x"
end

function PANEL:SetInverted( bool )
	self.inverted = bool
end

function PANEL:IsInverted()
	return self.inverted or false
end

function PANEL:SetHalfway( bool )
	self.halfway = bool
end

function PANEL:GetHalfway()
	return self.halfway or false
end

function PANEL:SetFont( str )
	self.font = str
end

function PANEL:GetFont()
	return self.font or "qtn"
end

function PANEL:SetColor( args )
	self.color = args
end

function PANEL:GetColor()
	return self.color or Color(255, 255, 255)
end

function PANEL:SetText( str )
	self.text = str
end

function PANEL:GetText()
	return self.text or "?@&#*!"
end

vgui.Register("SlidingText", PANEL, "DPanel")
