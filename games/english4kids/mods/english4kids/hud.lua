
e4k.attachHud = function(player)
  print("initializing hud")
  minetest.after(2, function()
    local idx = player:hud_add({
             hud_elem_type = "text",
             position = {x = 0.65, y = 0.88},
             offset = {x=0, y = 0},
             scale = {x = 100, y = 100},
             text = "COINS: "..e4k.state.coins,
             number = 0xFF0000
    })
  end)
end

print("hud registered") 
