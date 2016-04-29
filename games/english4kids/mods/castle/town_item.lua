-- intllib support
local S
if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
else
  S = function ( s ) return s end
end

local IMMORTAL_NODES = 1

minetest.register_node("castle:light",{
	drawtype = "glasslike",
	description = S("light block"),
	sunlight_propagates = true,
	light_source = 14,
	tiles = {"castle_street_light.png"},
	groups = {immortal=IMMORTAL_NODES},
	paramtype = "light",
	sounds = default.node_sound_glass_defaults()
})
