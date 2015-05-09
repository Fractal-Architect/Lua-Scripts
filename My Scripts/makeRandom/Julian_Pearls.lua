--[[
Copyright 2008 shortgreenpigg.deviantart.com

This script is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This script is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

See <http://www.gnu.org/licenses/>.
--]]
-- Julian Pearls by Shortgreenpigg  shortgreenpigg.deviantart.com

require("Utils")
FA.quality_adjust(3)

local a = -0.5 + math.random()
local b = -0.5 + math.random()
local r = math.random()*360
local c = math.random()

local requiredVariations = { "bubble", "pre_blur", "julian", "spherical" }

-- if the current variation set does not support these, switch to Flam3 Legacy variation set --
if not variationSet.hasVariations(requiredVariations) then
    variationSet.switchToVariationSetWithName("Flam3 Legacy")
end

-- the "flame" variable is where the app expects you to store your new fractal - it is Lua table named "flame"
flame = makeBlankFractal(8)   -- creates a blank fractal with 2 Xforms (creates normal Xaos from/to matrix as well )

-- First Xform -----------------
local xform = flame.xforms[1]

table.insert(xform.variations, { name="bubble",   weight=0.15 })
table.insert(xform.variations, { name="pre_blur", weight=1 })

xform.weight = 0.1
xform.color = c
xform.symmetry = -0.9

affine_translate(xform, a, b)
affine_Prot(xform, r)

-- 2nd Xform -----------------
xform = flame.xforms[2]

table.insert(xform.variations, { name="bubble",   weight=0.15 })
table.insert(xform.variations, { name="pre_blur", weight=0.2 })

xform.weight = 0.15
xform.color = c
xform.symmetry = -0.9

affine_translate(xform, a, b)
affine_Prot(xform, r)

-- 3rd Xform -----------------
xform = flame.xforms[3]

table.insert(xform.variations, { name="bubble",   weight=0.15 })

xform.weight = 0.25
xform.color = c
xform.symmetry = -0.9

affine_translate(xform, a, b)
affine_Prot(xform, r)

-- 4th Xform -----------------
xform = flame.xforms[4]

table.insert(xform.variations, { name="julian", weight=0.5 + math.random()*1.5, julian_power = 2, julian_dist = -1 })

xform.weight = 2.5 + math.random()*1.5
xform.color = math.random()/4
xform.symmetry = 0.995

affine_translate(xform, -0.35 + math.random()*0.7, -0.35 + math.random()*0.7)
affine_Prot(xform, 45*math.random()/2)

-- 5th Xform -----------------
xform = flame.xforms[5]

table.insert(xform.variations, { name="julian", weight=0.2, julian_power = 8 + math.random()*20, julian_dist = 1 })

xform.weight = 1
xform.color = math.random()
xform.symmetry = 1 - math.random()*0.5

affine_translate(xform, math.pow(-1, math.floor(math.random()*10))*(math.random()/2), math.pow(-1, math.floor(math.random()*10))*(math.random()/2))
affine_Prot(xform, 45*math.random()*10)

-- 6th Xform -----------------
xform = flame.xforms[6]

table.insert(xform.variations, { name="julian", weight=0.2 + math.random()*0.2, julian_power = 5 + math.random()*15, julian_dist = -1 })

xform.weight = 1
xform.color = math.random()
xform.symmetry = 0.995*math.random()

affine_translate(xform, math.pow(-1, math.floor(math.random()*5))*(math.random()/4), math.pow(-1, math.floor(math.random()*5))*(math.random()/4))
affine_Prot(xform, 45*math.random()*10)

-- 7th Xform -----------------
xform = flame.xforms[7]

table.insert(xform.variations, { name="julian", weight=0.2 + math.random()*0.2, julian_power = 5 + math.random()*25, julian_dist = 1 })

xform.weight = 1
xform.color = math.random()
xform.symmetry = -1*math.random()

affine_translate(xform, math.pow(-1, math.floor(math.random()*2.5))*(math.random()/8), math.pow(-1, math.floor(math.random()*2.5))*(math.random()/8))
affine_Prot(xform, 45*math.random()*10)

-- 8th Xform -----------------
xform = flame.xforms[8]

table.insert(xform.variations, { name="julian", weight=0.2 + math.random()*0.2, julian_power = 5 + math.random()*25, julian_dist = -1 })

xform.weight = 1
xform.color = math.random()
xform.symmetry = 0.95*math.random()

affine_translate(xform, math.pow(-1, math.floor(math.random()*1.5))*(math.random()/5), math.pow(-1, math.floor(math.random()*1.5))*(math.random()/5))
affine_Prot(xform, 45*math.random()*10)

-- Final Xform -----------------
flame.finalxform = makeBlankFinalXform()

flame.finalxform.variations[1] = { name = "spherical", weight = 1 }

affine_translate(flame.finalxform, (math.random()*1.50)-0.75,(math.random()*1.50)-0.75);
affine_Prot (flame.finalxform, (math.random() * 360));

flame.brightness = 6.5
flame.gamma = 4
flame.width = 400
flame.height = 300
