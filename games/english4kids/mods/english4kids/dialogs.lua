e4k.dialogs = {}

-- intllib support
local S
if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
else
  S = function ( s ) return s end
end

--[[ This function shows a simple dialog window with scrollable text
	name: name of the player to show the formspec to
	caption: Caption of the dialog window (not escaped)
	text: The text to be shown. Must be escaped manually for formspec, an unescaped
	      comma generates a line break.
]]
function e4k.dialogs.show_default_dialog(name, caption, text)
	local formspec = "size[12,6]"..
	"label[-0.15,-0.4;"..minetest.formspec_escape(caption).."]"..
	"tablecolumns[text]"..
	"tableoptions[background=#000000;highlight=#000000;border=false]"..
	"table[0,0.25;12,5.2;text_table;"..
	tutorial.convert_newlines(minetest.formspec_escape(S(text)))..
	"]"..
	"button_exit[4.5,5.5;3,1;close;"..S("Close").."]"
	minetest.show_formspec(name, "tutorial_dialog", formspec)
end
