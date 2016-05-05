
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

  animation_speed = 30,
  animation_blend = 0
}

NPC_ENTITY_DEF.on_activate = function(self)
  self.object:set_armor_groups({immortal = 1})
	self.anim = npc_get_animations_def()
  --30: animation speed, 0: animation_blend
	self.object:set_animation({x=self.anim.stand_START,y=self.anim.stand_END}, self.animation_speed, self.animation_blend)
	self.npc_anim = ANIM_STAND
	self.object:setacceleration({x=0,y=-10,z=0})
	self.state = 1
	self.object:set_hp(50)
end

NPC_ENTITY_DEF.on_punch = function(self, puncher)
	if puncher:is_player() then
    local playername = puncher:get_player_name()
    minetest.chat_send_player(playername, "Hello, may you help me?")
    e4k.dialogs.show_default_dialog(playername, "welcome!", "Hello, can you help me?")
    minetest.sound_play("hello_may_you_help_me", {to_player= playername})
  end
end

NPC_ENTITY_DEF.on_step = function(self, dtime)
	self.timer = self.timer + 0.01
	self.turn_timer = self.turn_timer + 0.01

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
	end
end

minetest.register_entity("english4kids:npc_welcomer", NPC_ENTITY_DEF)
