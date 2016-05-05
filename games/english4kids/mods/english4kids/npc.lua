--[[
base "class" for all NPC. 
we attach a specific behavior to a NPC in order
to vary his.. well.. behavior. 
]]--
e4k.NPC = {
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
  behavior = nil,
  animation_speed = 30,
  animation_blend = 0,
}

e4k.NPC.on_activate = function(self)
  self.object:set_armor_groups({immortal = 1})
	self.anim = npc_get_animations_def()
	self.object:set_animation({x=self.anim.stand_START,y=self.anim.stand_END}, self.animation_speed, self.animation_blend)
	self.npc_anim = ANIM_STAND
	self.object:setacceleration({x=0,y=-10,z=0})
	self.state = 1
	self.object:set_hp(50)
  --self.get_behavior()
end


e4k.NPC.set_behavior = function(self, behavior)
  print("set_behavior ")
  --make persistent the behavior type
  local pos = self.getpos(self)
  print(pos)
  local meta = minetest.get_meta(pos)
  print(meta)
  local class = behavior["class"]
  print(class)
  meta:set_string("behavior", class)
end

e4k.NPC.get_behavior = function(self)
  print("get_behavior")
  if self.behavior ~= nil then
    print("found behavior")
  else 
    print("not found behavior")
    local pos = self.object:getpos()
    print(pos)
    local meta = minetest.get_meta(pos)
    print(meta)
    local class = meta.get_string(meta, "behavior")
    print(class)
    if class == nil or class == "" then
      print("no class")
      return
    end
    self.behavior = e4k.behaviors[class]
    print(self.behavior)
  end
  return self.behavior
end

e4k.NPC.on_init = function(self)
  e4k.NPC.get_behavior().init(self)
end

e4k.NPC.on_punch = function(self, puncher)
	local b = self.get_behavior(self)
  if b ~= nil then
    b.on_punch(self, puncher)
  else
    print("ERROR: behavor is nul")
  end
    --[[if puncher:is_player() then
    local playername = puncher:get_player_name()
    minetest.chat_send_player(playername, "Hello, may you help me?")
    e4k.dialogs.show_default_dialog(playername, "welcome!", "Hello, can you help me?")
    minetest.sound_play("hello_may_you_help_me", {to_player= playername})
  end
  --]]
end

e4k.NPC.on_step = function(self, dtime)
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

		if self.turn_timer > math.random(1,4) and self.yawwer == true then
			self.yaw = 360 * math.random()
			self.object:setyaw(self.yaw)
			self.turn_timer = 0
		end
		self.object:setvelocity({x=0,y=self.object:getvelocity().y,z=0})

    if self.behavior ~= nil then
      self.behavior.step(self, dtime)
    end
end

minetest.register_entity("english4kids:npc_welcomer", e4k.NPC)
