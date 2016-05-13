
e4k.attachHud = function(player)
  print("initializing hud")
  minetest.after(2, function()
    local hud_coins = player:hud_add({
             hud_elem_type = "text",
             position = {x = 0.65, y = 0.88},
             offset = {x=0, y = 0},
             scale = {x = 100, y = 100},
             text = "COINS: ",
             number = 0xFF0000
    })
    print("attached HUD_COINS "..tostring(hud_coins))
    e4k.setMetadataInt(player, "hud_coins", hud_coins)
    --force refresh hud
    e4k.incCoins(player, 0) 
  end)
end

print("hud registered") 
