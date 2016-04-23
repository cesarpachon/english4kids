-- NPC max walk speed
walk_limit = 2
--npc just walking around
chillaxin_speed = 1.5
-- Player animation speed
animation_speed = 30

-- Player animation blending
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
animation_blend = 0

-- Default player appearance
default_model_def = "character.x"

--[[
available_npc_textures_def = {
	def_texture_1 = {"miner.png"},
	def_texture_2 = {"archer.png"},
	def_texture_3 = {"cool_girl.png"},
	def_texture_4 = {"builder.png"},
	def_texture_5 = {"panda_girl.png"}
}
]]--

-- Frame ranges for each player model
function npc_get_animations_def(model)
	if model == "character.x" then
		return {
		stand_START = 0,
		stand_END = 79,
		sit_START = 81,
		sit_END = 160,
		lay_START = 162,
		lay_END = 166,
		walk_START = 168,
		walk_END = 187,
		mine_START = 189,
		mine_END = 198,
		walk_mine_START = 200,
		walk_mine_END = 219
		}
	end
end

local npc_model = {}
local npc_anim = {}
local npc_sneak = {}
local ANIM_STAND = 1
local ANIM_SIT = 2
local ANIM_LAY = 3
local ANIM_WALK  = 4
local ANIM_WALK_MINE = 5
local ANIM_MINE = 6

function npc_update_visuals_def(self)
	visual = default_model_def
	npc_anim = 0 -- Animation will be set further below immediately
	local prop = {
		mesh = default_model_def,
		textures = {"panda_girl.png"},
    --textures = default_textures,
		--textures = available_npc_textures_def["def_texture_"..math.random(1,5)],
		visual_size = {x=1, y=1, z=1}
    --armor_groups = {immortal = 1}
  }
	self.object:set_properties(prop)
  self.object:set_armor_groups({immortal = 1})
end

NPC_ENTITY_DEF = {
	physical = true,
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	visual = "mesh",
	mesh = "character.x",
	textures = {"panda_girl.png"},
	npc_anim = 0,
	timer = 0,
	turn_timer = 0,
	vec = 0,
	yaw = 0,
	yawwer = 0,
	state = 1,
	jump_timer = 0,
	door_timer = 0,
	attacker = "",
	attacking_timer = 0
}

NPC_ENTITY_DEF.on_activate = function(self)
  npc_update_visuals_def(self)
	self.anim = npc_get_animations_def(visual)
	self.object:set_animation({x=self.anim.stand_START,y=self.anim.stand_END}, animation_speed_mod, animation_blend)
	self.npc_anim = ANIM_STAND
	self.object:setacceleration({x=0,y=-10,z=0})
	self.state = 1
	self.object:set_hp(50)
end

NPC_ENTITY_DEF.on_punch = function(self, puncher)
	for  _,object in ipairs(minetest.env:get_objects_inside_radius(self.object:getpos(), 5)) do
		if not object:is_player() then
			if object:get_luaentity().name == "english4kids:npc_welcomer" then
				print("hello! can you help me?")
        object:get_luaentity().state = 3
				object:get_luaentity().attacker = puncher:get_player_name()
			end
		end
	end

	if self.state ~= 3 then
		self.state = 3
		self.attacker = puncher:get_player_name()
	end

	if self.object:get_hp() == 0 then
	    local obj = minetest.env:add_item(self.object:getpos(), "default:stone_with_iron 10")
	end
end

NPC_ENTITY_DEF.on_step = function(self, dtime)
	self.timer = self.timer + 0.01
	self.turn_timer = self.turn_timer + 0.01
	self.jump_timer = self.jump_timer + 0.01
	self.door_timer = self.door_timer + 0.01
	self.attacking_timer = self.attacking_timer + 0.01

	local current_pos = self.object:getpos()
	local current_node = minetest.env:get_node(current_pos)
	if self.time_passed == nil then
		self.time_passed = 0
	end

	self.time_passed = self.time_passed + dtime

	if self.time_passed >= 5 then
		self.object:remove()
	else
	if current_node.name == "default:water_source" or
	current_node.name == "default:water_flowing" or
	current_node.name == "default:lava_source" or
	current_node.name == "default:lava_flowing"
	then
		self.time_passed =  self.time_passed + dtime
	else
		self.time_passed = 0
	end
end

	--collision detection prealpha
	--[[
	for  _,object in ipairs(minetest.env:get_objects_inside_radius(self.object:getpos(), 2)) do
		if object:is_player() then
			compare1 = object:getpos()
			compare2 = self.object:getpos()
			newx = compare2.x - compare1.x
			newz = compare2.z - compare1.z
			print(newx)
			print(newz)
			self.object:setacceleration({x=newx,y=self.object:getacceleration().y,z=newz})
		elseif not object:is_player() then
			if object:get_luaentity().name == "peaceful_npc:npc" then
				print("moo")
			end
		end
	end
	]]--

	--set npc to hostile in night, and revert npc back to peaceful in daylight
	if minetest.env:get_timeofday() >= 0 and minetest.env:get_timeofday() < 0.25 and self.state ~= 4 then
		self.state = 4
	elseif minetest.env:get_timeofday() > 0.25 and self.state == 4 then
		self.state = 1
	end
	--if mob is not in attack or hostile mode, set mob to walking or standing
	if self.state < 3 then
		if self.timer > math.random(1,20) then
			self.state = math.random(1,2)
			self.timer = 0
		end
	end
	--STANDING
	if self.state == 1 then
		self.yawwer = true
		for  _,object in ipairs(minetest.env:get_objects_inside_radius(self.object:getpos(), 3)) do
			if object:is_player() then
				self.yawwer = false
				local NPC = self.object:getpos()
				local PLAYER = object:getpos()
				self.vec = {x=PLAYER.x-NPC.x, y=PLAYER.y-NPC.y, z=PLAYER.z-NPC.z}
				self.yaw = math.atan(self.vec.z/self.vec.x)+math.pi^2
				if PLAYER.x > NPC.x then
					self.yaw = self.yaw + math.pi
				end
				self.yaw = self.yaw - 2
				self.object:setyaw(self.yaw)
			end
		end

		if self.turn_timer > math.random(1,4) and yawwer == true then
			self.yaw = 360 * math.random()
			self.object:setyaw(self.yaw)
			self.turn_timer = 0
		end
		self.object:setvelocity({x=0,y=self.object:getvelocity().y,z=0})
		if self.npc_anim ~= ANIM_STAND then
			self.anim = npc_get_animations_def(visual)
			self.object:set_animation({x=self.anim.stand_START,y=self.anim.stand_END}, animation_speed_mod, animation_blend)
			self.npc_anim = ANIM_STAND
		end
	end
	--WALKING
	if self.state == 2 then
		if self.present_timer == 1 then
			minetest.env:add_item(self.object:getpos(),"default:coal_lump")
			self.present_timer = 0
		end
		if self.direction ~= nil then
			self.object:setvelocity({x=self.direction.x*chillaxin_speed,y=self.object:getvelocity().y,z=self.direction.z*chillaxin_speed})
		end
		if self.turn_timer > math.random(1,4) then
			self.yaw = 360 * math.random()
			self.object:setyaw(self.yaw)
			self.turn_timer = 0
			self.direction = {x = math.sin(self.yaw)*-1, y = -10, z = math.cos(self.yaw)}
			--self.object:setvelocity({x=self.direction.x,y=self.object:getvelocity().y,z=direction.z})
			--self.object:setacceleration(self.direction)
		end
		if self.npc_anim ~= ANIM_WALK then
			self.anim = npc_get_animations_def(visual)
			self.object:set_animation({x=self.anim.walk_START,y=self.anim.walk_END}, animation_speed_mod, animation_blend)
			self.npc_anim = ANIM_WALK
		end
		--open a door [alpha]
		if self.direction ~= nil then
			if self.door_timer > 2 then
				local is_a_door = minetest.env:get_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y,z=self.object:getpos().z + self.direction.z}).name
				if is_a_door == "doors:door_wood_t_1" then
					minetest.env:punch_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y-1,z=self.object:getpos().z + self.direction.z})
					self.door_timer = 0
				end
				local is_in_door = minetest.env:get_node(self.object:getpos()).name
				if is_in_door == "doors:door_wood_t_1" then
					minetest.env:punch_node(self.object:getpos())
				end
			end
		end
		--jump
		if self.direction ~= nil then
			if self.jump_timer > 0.3 then
				if minetest.env:get_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y-1,z=self.object:getpos().z + self.direction.z}).name ~= "air" then
					self.object:setvelocity({x=self.object:getvelocity().x,y=5,z=self.object:getvelocity().z})
					self.jump_timer = 0
				end
			end
		end
	end
	--WANDERING CONSTANTLY AT NIGHT
	if self.state == 4 then
		if self.npc_anim ~= ANIM_WALK then
			self.anim = npc_get_animations_def(visual)
			self.object:set_animation({x=self.anim.walk_START,y=self.anim.walk_END}, animation_speed_mod, animation_blend)
			self.npc_anim = ANIM_WALK
		end
		for  _,object in ipairs(minetest.env:get_objects_inside_radius(self.object:getpos(), 12)) do
			if object:is_player() then
				if object:get_hp() > 0 then
					NPC = self.object:getpos()
					PLAYER = object:getpos()
					self.vec = {x=PLAYER.x-NPC.x, y=PLAYER.y-NPC.y, z=PLAYER.z-NPC.z}
					self.yaw = math.atan(self.vec.z/self.vec.x)+math.pi^2
					if PLAYER.x > NPC.x then
						self.yaw = self.yaw + math.pi
					end
					self.yaw = self.yaw - 2
					self.object:setyaw(self.yaw)
					self.direction = {x = math.sin(self.yaw)*-1, y = 0, z = math.cos(self.yaw)}
					if self.direction ~= nil then
						self.object:setvelocity({x=self.direction.x*2.5,y=self.object:getvelocity().y,z=self.direction.z*2.5})
					end
					--jump over obstacles
					if self.jump_timer > 0.3 then
						if minetest.env:get_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y-1,z=self.object:getpos().z + self.direction.z}).name ~= "air" then
							self.object:setvelocity({x=self.object:getvelocity().x,y=5,z=self.object:getvelocity().z})
							self.jump_timer = 0
						end
					end
					if self.direction ~= nil then
						if self.door_timer > 2 then
							local is_a_door = minetest.env:get_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y,z=self.object:getpos().z + self.direction.z}).name
							if is_a_door == "doors:door_wood_t_1" then
								minetest.env:punch_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y-1,z=self.object:getpos().z + self.direction.z})
								self.door_timer = 0
							end
							local is_in_door = minetest.env:get_node(self.object:getpos()).name
							if is_in_door == "doors:door_wood_t_1" then
								minetest.env:punch_node(self.object:getpos())
							end
						end
					end
				--return
				end
			elseif not object:is_player() then
				self.state = 1
				self.attacker = ""
			end
		end
		if self.direction ~= nil then
			self.object:setvelocity({x=self.direction.x,y=self.object:getvelocity().y,z=self.direction.z})
		end
		if self.turn_timer > math.random(1,4) then
			self.yaw = 360 * math.random()
			self.object:setyaw(self.yaw)
			self.turn_timer = 0
			self.direction = {x = math.sin(self.yaw)*-1, y = -10, z = math.cos(self.yaw)}
		end
		if self.npc_anim ~= ANIM_WALK then
			self.anim = npc_get_animations_def(visual)
			self.object:set_animation({x=self.anim.walk_START,y=self.anim.walk_END}, animation_speed_mod, animation_blend)
			self.npc_anim = ANIM_WALK
		end
		--open a door [alpha]
		if self.direction ~= nil then
			if self.door_timer > 2 then
				local is_a_door = minetest.env:get_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y,z=self.object:getpos().z + self.direction.z}).name
				if is_a_door == "doors:door_wood_t_1" then
					--print("door")
					minetest.env:punch_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y-1,z=self.object:getpos().z + self.direction.z})
					self.door_timer = 0
				end
				local is_in_door = minetest.env:get_node(self.object:getpos()).name
				--print(dump(is_in_door))
				if is_in_door == "doors:door_wood_t_1" then
					minetest.env:punch_node(self.object:getpos())
				end
			end
		end
		--jump
		if self.direction ~= nil then
			if self.jump_timer > 0.3 then
				--print(dump(minetest.env:get_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y-1,z=self.object:getpos().z + self.direction.z})))
				if minetest.env:get_node({x=self.object:getpos().x + self.direction.x,y=self.object:getpos().y-1,z=self.object:getpos().z + self.direction.z}).name ~= "air" then
					self.object:setvelocity({x=self.object:getvelocity().x,y=2.5,z=self.object:getvelocity().z})
					self.jump_timer = 0
				end
			end
		end
	end
end

minetest.register_entity("english4kids:npc_welcomer", NPC_ENTITY_DEF)
