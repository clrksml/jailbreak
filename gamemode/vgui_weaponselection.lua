local PANEL = {}

function PANEL:Init()
	self:SetZPos(-99999)
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self.Paint = function(self, width, height)
		surface.DrawBox(0, 0, width, height, Color(1, 1, 1, 150))
	end
	self.Think = function()	end
	self.Refresh = function()
		local DPanel = vgui.Create("DPanel", self)
		DPanel:SetPos(0, 0)
		DPanel:SetSize(300, 100)
		DPanel.Paint = function(self, width, height)
			surface.DrawBox(0, 0, width, height, Color(255, 255, 255))
		end
	end
end

vgui.Register("WeaponSelection", PANEL, "DPanel")
