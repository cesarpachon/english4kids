--a namespace for this mod.. 
e4k = {}

--store the behaviors definitions
e4k["behaviors"] = {}

dofile(minetest.get_modpath("english4kids").."/dialogs.lua")
dofile(minetest.get_modpath("english4kids").."/common.lua")
dofile(minetest.get_modpath("english4kids").."/npc.lua")
dofile(minetest.get_modpath("english4kids").."/behavior_welcomer.lua")

-- Saves tutorial state into file
function e4k.save_state()
	local str = minetest.serialize(e4k.state)
	local filepath = minetest.get_worldpath().."/state.mt"
	local file = io.open(filepath, "w")
	if(file) then
		file:write(str)
		minetest.log("action", "[e4k] Tutorial state has been written into "..filepath..".")
	else
		minetest.log("error", "[e4k] An attempt to save the tutorial state into "..filepath.." failed.")
	end
end

--
-- create all the npc the first time a player joins the world
--
function e4k.create()
  print("e4k.create: first time here? let's create everything..")
  local pos = { x=46, y=2, z=36}
  local obj = minetest.env:add_entity(pos, ("english4kids:npc_welcomer"))
  -- manual trigger init behavior. lets hope activate will trigger for existing nodes!  
   e4k.NPC.set_behavior(obj, "welcomer")
  
  --_debug(npc)
  --npc.set_behavior(e4k.behaviors["welcomer"])
  --npc.init()
  
  e4k.state.first_join = false
  e4k.save_state()
  minetest.after(1, function()
    print("First Environment step run")
  end)
end



-- load tutorial state from file

local filepath = minetest.get_worldpath().."/state.mt"
local file = io.open(filepath, "r")
local read = false
if file then
	local string = file:read()
	io.close(file)
	if(string ~= nil) then
		e4k.state = minetest.deserialize(string)
		minetest.log("action", "[e4k] Tutorial state has been read from "..filepath..".")
		read = true
	end
end
if(read==false) then
	e4k.state = {}
	-- Is this the first time the player joins this e4k?
	e4k.state.first_join = true
	-- These variables store wheather a message for those events has been shown yet.
end

minetest.register_on_joinplayer(function()
  if(e4k.state.first_join) then
    e4k.create()
  end
end)



print("english4kids loaded!")


