experimental subgame for minecraft, 
based on the "tutorial" game 

http://wiki.minetest.net/Subgames

Lua API reference
http://dev.minetest.net/Category:Methods
http://rubenwardy.com/minetest_modding_book/lua_api.html
http://dev.minetest.net/LuaEntitySAO

for developing, create sym links from minetest folder to repo subfolders: 

 ln -s ~/Projects/english4kids/worlds/english4kids/ ~/.minetest/worlds/english4kids
 ln -s ~/Projects/english4kids/games/english4kids/ ~/.minetest/games/english4kids

 about immortal nodes

 I changed some nodes to use IMMORTAL_NODE = nil in 
 mods/tutorial/init.lua

 but there is also nodes with immortal group in:
 mods/darkage/nodes.lua

and all the nodes of cottages..
and in supplemental.. 

 humm.. why castle:light can't be destroyed in the map,
 even if it is a just placed node?



