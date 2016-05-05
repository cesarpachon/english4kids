-- NPC max walk speed


--[[
available_npc_textures_def = {
	def_texture_1 = {"miner.png"},
	def_texture_2 = {"archer.png"},
	def_texture_3 = {"cool_girl.png"},
	def_texture_4 = {"builder.png"},
	def_texture_5 = {"panda_girl.png"}
}
]]--

ANIM_STAND = 1
ANIM_SIT = 2
ANIM_LAY = 3
ANIM_WALK  = 4
ANIM_WALK_MINE = 5
ANIM_MINE = 6

-- Frame ranges for each player model
function npc_get_animations_def()
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

function _debug(t)
  for i, v in ipairs(t) do
    print(i, v) 
  end
end


function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
