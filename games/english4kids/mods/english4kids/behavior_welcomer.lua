-- welcomer behavior
local WELCOMER = {
}

WELCOMER.class = "welcomer"

WELCOMER.click_counter = 0; 
WELCOMER.msg1_en = "Welcome to the castle! to find diamonds, follow the clues"
WELCOMER.msg1_es = "Bienvenido al castillo! para encontrar diamantes, sigue las pistas"

WELCOMER.init = function(self)
  print("init welcomer")
  self.click_counter = 0; 
end

WELCOMER.step = function(self, dtime)
  
end

WELCOMER.on_punch = function(self, puncher)
  if not puncher:is_player() then
    return
  end
  local playername = puncher:get_player_name()
  self.click_counter = self.click_counter +  1; 
  print(self.click_counter) 
   --only audio
  minetest.sound_play("hello_may_you_help_me", {to_player= playername})
  if self.click_counter > 1 then
   --..and text in the chat
    minetest.chat_send_player(playername, WELCOMER.msg1_en)
  end

  if self.click_counter > 2 then
   -- dialog in english with vocabulary  
    e4k.dialogs.show_default_dialog(playername, WELCOMER.msg1_en, "welcome = bienvenido, castle = castillo, clues = pistas")
  end

  if self.click_counter > 3 then
    -- dialog in spanish
    e4k.dialogs.show_default_dialog(playername, WELCOMER.msg1_en, WELCOMER.msg1_es)
   self.click_counter = 0;  
  end
end

e4k.behaviors["welcomer"] = WELCOMER
print("behavior_welcomer registered") 
