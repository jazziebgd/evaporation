require("lib.config")

if not jazziebgd then jazziebgd = {} end
if not jazziebgd.lib then jazziebgd.lib = {} end

require("prototypes.styles")

require("prototypes.category")
require("prototypes.recipe-category")

require("prototypes.item.microwave-evaporator")
require("prototypes.recipe.crafting.microwave-evaporator")

require("prototypes.entity.evaporator")
require("prototypes.item.evaporator")
require("prototypes.recipe.evaporator")

require("prototypes.entity.advanced-evaporator")
require("prototypes.item.advanced-evaporator")
require("prototypes.recipe.advanced-evaporator")

require("prototypes.technology.evaporation")
require("prototypes.technology.advanced-evaporation")

data:extend{
    {
        type = 'custom-input',
        name = 'toggle-evaporation-gui',
        key_sequence = 'SHIFT + E',
        consuming = 'all',
    }
}
