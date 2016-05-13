--a namespace for this mod.. 
e4k = {}

--store the behaviors definitions
e4k["behaviors"] = {}

dofile(minetest.get_modpath("english4kids").."/dialogs.lua")
dofile(minetest.get_modpath("english4kids").."/common.lua")
dofile(minetest.get_modpath("english4kids").."/npc.lua")
dofile(minetest.get_modpath("english4kids").."/behavior_welcomer.lua")
dofile(minetest.get_modpath("english4kids").."/hud.lua")

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

-- set the value of a integer metadata
function e4k.setMetadataInt(player, key, ival)
  local pos = {x=0, y=0, z=0}--player:getpos()
  local meta = minetest.get_meta(pos)
  print("setInt: "..player:get_player_name().." "..key.." " .. tostring(ival))
  meta:set_int(key, ival)
end

-- increment a integer metadata
function e4k.incMetadataInt(player, key, ival)
  local v = e4k.getMetadataInt(player, key)
  v = v + ival
  print("incInt: "..player:get_player_name().." "..key.." " .. tostring(v))
  e4k.setMetadataInt(player, key, v)
end

-- get a integer metadata. returns 0 if no exist
function e4k.getMetadataInt(player, key)
  local pos = {x=0, y=0, z=0}--player:getpos()
  local meta = minetest.get_meta(pos)
  local val = meta:get_int(key)
  print("getInt: "..player:get_player_name().." "..key.." " .. tostring(val))
  return val
end

--add or substract coins. update HUD
function e4k.incCoins(player, deltaCoins)
  print("inc coins: "..player:get_player_name().." "..tostring(deltaCoins))
  e4k.incMetadataInt(player, "coins", deltaCoins)
  e4k.refreshHud(player)
end


--
-- create all the npc the first time a player joins the world
--
function e4k.create(player)
  print("e4k.create: first time here? let's create everything..")
  --default settings for the player
  e4k.setMetadataInt(player, "coins", 20)
  --the welcomer npc
  local pos = { x=46, y=2, z=36}
  local sao = minetest.env:add_entity(pos, ("english4kids:npc"))
  local entity = sao:get_luaentity()
  entity:set_behavior(e4k.behaviors["welcomer"])
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
	e4k.state.first_join = true
  e4k.state.coins = 10
end

minetest.register_on_joinplayer(function(player)
  if(e4k.state.first_join) then
    e4k.create(player)
  end
  e4k.attachHud(player)
  e4k.state.first_join = false
  e4k.save_state()
end)

print("english4kids loaded!")
