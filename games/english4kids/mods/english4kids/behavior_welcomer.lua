-- welcomer behavior
local WELCOMER = {
}

WELCOMER.class = "welcomer"

WELCOMER.click_counter = 0; 

WELCOMER.init = function(self)
  print("init welcomer")
  self.click_counter = 0; 
end

WELCOMER.step = function(self, dtime)
  
end

WELCOMER.on_punch = function(self, puncher)
  self.click_counter = self.click_counter +  1; 
  print("punch welcomer")
  print(self.click_counter) 
end

e4k.behaviors["welcomer"] = WELCOMER
print("behavior_welcomer registered") 
