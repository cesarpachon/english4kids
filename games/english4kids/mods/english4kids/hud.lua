
e4k.attachHud = function(player)
  print("initializing hud")
  minetest.after(1, function()
    local hud_coins = player:hud_add({
             hud_elem_type = "text",
             position = {x = 0.65, y = 0.88},
             offset = {x=0, y = 0},
             scale = {x = 100, y = 100},
             text = "COINS: ",
             number = 0xFF0000
    })
    e4k.setMetadataInt(player, "hud_coins", hud_coins)
    minetest.after(1, function()
      e4k.refreshHud(player)
    end)
  end)
end

function e4k.refreshHud(player)
  local hud_coins = e4k.getMetadataInt(player, "hud_coins")
  local coins = e4k.getMetadataInt(player, "coins")
  player:hud_change(hud_coins, "text", "COINS:"..tostring(coins))
end

print("hud registered") 
