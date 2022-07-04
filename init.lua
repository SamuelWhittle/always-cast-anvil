-- FILE PATHS
local base_wand_path = "data/entities/base_wand.xml"
local forge_convert_path = "data/scripts/buildings/forge_item_convert.lua"
local forge_wand_action_path = "mods/always-cast-anvil/files/forge_wand_action.lua"

-- MAKES WANDS FORGEABLE AND SPARKLY
local base_wand = ModTextFileGetContent(base_wand_path)
ModTextFileSetContent(base_wand_path, string.gsub(base_wand, "tags=\"", "tags=\"forgeable,"))


local forge_convert = ModTextFileGetContent(forge_convert_path)
ModTextFileSetContent(forge_convert_path, string.gsub(forge_convert, "local converted = false", ModTextFileGetContent(forge_wand_action_path)))