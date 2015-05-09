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

-- Edisc Julian Script by Shortgreenpigg
--  shortgreenpigg.deviantart.com

require("Utils")

local requiredVariations = { "zscale", "zcone", "ztranslate", "julian", "juliascope", "hemisphere", "edisc", "post_flatten", "julia3D", "julia3Dz" }

if not variationSet.hasVariations(requiredVariations) then
    if not variationSet.switchToFirstVariationSetWithRequiredVariations(requiredVariations) then
        local uuid = variationSet.makeSetWithVariations(requiredVariations, "EdiscJulian3D")
        if uuid and not variationSet.switchToVariationSetWithUuid(uuid) then
            require("Linear")
            return
        end
    end
end

-- the "flame" variable is where the app expects you to store your new fractal - it is Lua table named "flame"
flame = makeBlankFractal(4)

local j = math.random(1, 4)     --  1-4   Choose between Julian (1), Juliascope (2), Julia2D (3), Julia3Dz (4)

-- First Xform -----------------
local xform = flame.xforms[1]

table.insert(xform.variations, { name="zscale",     weight=0.6 })
table.insert(xform.variations, { name="zcone",      weight=-0.04})
table.insert(xform.variations, { name="ztranslate", weight=-0.06 })
table.insert(xform.variations, { name="hemisphere", weight=math.random()*0.15 })
if j == 1 then
	table.insert(xform.variations, { name="julian",  weight=0.725 + math.random()*0.1, julian_power=-2, julian_dist=1 })
elseif j == 2 then
	table.insert(xform.variations, { name="juliascope",  weight=0.725 + math.random()*0.1, juliascope_power=-2, juliascope_dist=1 })
elseif j == 3 then
	table.insert(xform.variations, { name="julia3D",  weight=0.725 + math.random()*0.1, julia3D_power=-2 })
else	
	table.insert(xform.variations, { name="julia3Dz",  weight=0.725 + math.random()*0.1, julia3Dz_power=-2 })
end
if j == 1 or j == 2 then
	table.insert(xform.variations, { name="post_flatten",  weight=0.7 })
else
	table.insert(xform.variations, { name="post_flatten",  weight=0.6 })
end

xform.weight = 8
xform.color = math.random()
xform.symmetry = 0.5

affine_translate(xform, 0.39 + math.random()*0.025, 0)
affine_scale(xform, 0.212924)

xform.post[1][1] = 1.5625
xform.post[1][2] = 0
xform.post[2][1] = 0
xform.post[2][2] = 1.5625
xform.post[3][1] = 0
xform.post[3][2] = 0

-- 2nd Xform -----------------

local v = 0.3 + math.random()*0.1
local q = math.random()

xform = flame.xforms[2]

table.insert(xform.variations, { name="edisc",     weight=v })
table.insert(xform.variations, { name="post_flatten",     weight=0.8 })

xform.weight = 1
xform.color = q
xform.symmetry = -0.9

affine_translate(xform, -1 + math.random()*2, -1 + math.random()*2)
affine_Prot(xform, math.random()*360)

-- 3rd Xform -----------------

xform = flame.xforms[3]

table.insert(xform.variations, { name="julian",  weight=v, julian_power=30 + 30*math.random(), julian_dist=-1 - 2 *math.random() })
table.insert(xform.variations, { name="post_flatten",     weight=0.8 })

xform.weight = 1
xform.color = q
xform.symmetry = -0.9

affine_translate(xform, -1 + math.random()*2, -1 + math.random()*2)
affine_Prot(xform, math.random()*360)

-- 4th Xform -----------------

xform = flame.xforms[4]

table.insert(xform.variations, { name="julian",  weight=v + 0.08 + math.random()*0.04, julian_power=30 + 30*math.random(), julian_dist=1+ 2*math.random() })
table.insert(xform.variations, { name="post_flatten",     weight=0.8 })

xform.weight = 1
xform.color = q
xform.symmetry = -0.9

affine_translate(xform, -1 + math.random()*2, -1 + math.random()*2)
affine_Prot(xform, math.random()*360)

flame.width = 400
flame.height = 300
flame.scale = 50 + math.random() * 4
flame.rotate=90
flame.brightness=10

-- flame.background = { red=15, green=15, blue=15 }
