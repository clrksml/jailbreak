local PANEL = {}

function PANEL:Init()
	self.a, self.c = 0, CurTime() + 3

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
	self.Think = function()
		if self:IsInverted() then
			if self.a > 0.5 and self.a <= 255 then
				self.a = self.a - 0.5
			end
		else
			if self.a < 255 then
				self.a = self.a + 0.5
			end
		end

		if self.c < CurTime() then
			self:Remove()
		end
	end
	self.Refresh = function()
		self.c = CurTime() + 3

		if self:IsInverted() then
			self.a = 255
		else
			self.a = 0
		end

		surface.SetFont(self:GetFont())

		local w, h = surface.GetTextSize(self:GetText())
		local color, font, text = self:GetColor(), self:GetFont(), self:GetText()

		local DPanel = vgui.Create("DPanel", self)
		DPanel:SetPos((self:GetWide() / 2) - (w / 2), (self:GetTall() / 2) - (h / 2))
		DPanel:SetSize(w, h)
		DPanel.Paint = function(self, width, height)
			surface.DrawSentence(font, Color(color.r, color.g, color.b, self.a), 0, 0, text, true)
		end
	end
end

function PANEL:SetInverted( bool )
	self.inverted = bool
end

function PANEL:IsInverted()
	return self.inverted or false
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

vgui.Register("TTOText", PANEL, "DPanel")
