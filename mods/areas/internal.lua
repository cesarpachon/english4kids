-- Load the areas table from the save file
function areas:load()
	local file, err = io.open(self.config.filename, "r")
	if err then
		self.areas = self.areas or {}
		return err
	end
	self.areas = minetest.deserialize(file:read("*a"))
	if type(self.areas) ~= "table" then
		self.areas = {}
	end
	file:close()
end
