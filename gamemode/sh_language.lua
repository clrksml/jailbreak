
GM.Languages = {}

function GM:CreateLanguage( tbl )
	self.Languages[tbl.Name] = tbl
end

function GM:GetLanguage( str )
	for k, v in pairs(self.Languages) do
		if k == str then
			return v
		end
	end
	
	return self.Languages["english"]
end

function GM:GetLanguages( )
	return self.Languages
end
