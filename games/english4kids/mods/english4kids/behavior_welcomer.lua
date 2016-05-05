-- welcomer behavior

local WELCOMER = {}

WELCOMER.class = "welcomer"

WELCOMER.init = function(self)
  print("init welcomer")
end

WELCOMER.step = function(self, dtime)
  
end

WELCOMER.punch = function(self, puncher)
 print("punch welcomer")
end

print("bejavior_welcomer log")
print(e4k)
print(e4k.behaviors)
e4k.behaviors["welcomer"] = WELCOMER
