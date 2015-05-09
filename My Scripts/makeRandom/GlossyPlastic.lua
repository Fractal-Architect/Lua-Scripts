--[[
Copyright 2008 meckie.deviantart.com

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

--[[
{ ========================================= }
{ "Glossy Plastic-Script"                   }
{ Scripted By Meckie                        }
{ http://meckie.deviantart.com/             }
{                                           }
{ Requires Apophysis 2.07b                  }
{ Requires "Scry" variation.  		  }
{ ========================================= }]]

require("Utils")

requiredVariations = { "scry", "gaussian_blur", "eyefish", "spherical" }

-- if the current variation set does not support these, switch to Flam3 Legacy variation set --
if not variationSet.hasVariations(requiredVariations) then
    variationSet.switchToVariationSetWithName("Flam3 Legacy")
end

-- the "flame" variable is where the app expects you to store your new fractal - it is Lua table named "flame"
flame = makeBlankFractal(2)   -- creates a blank fractal with 2 Xforms (creates normal Xaos from/to matrix as well )

-- First Xform -----------------
local xform = flame.xforms[1]

table.insert(xform.variations, { name="gaussian_blur",   weight=0.9 })

xform.weight = 0.5
xform.color = math.random()
xform.symmetry = -1

affine_translate(xform, math.pow(-1, math.floor(math.random(1,10))) * 0.3*math.random(), 
					math.pow(-1, math.floor(math.random(1,10))) * 0.3*math.random())
affine_scale(xform, 0.4*math.random())

-- 2nd Xform -----------------
xform = flame.xforms[2]

local sign1 = math.pow(-1, math.random(1,10))
-- local sign2 = math.pow(-1, math.random(1,10))
-- local sign3 = math.pow(-1, math.random(1,10))
-- local sign1 = 1
local sign2 = 1
local sign3 = 1
table.insert(xform.variations, { name="scry",      weight= sign1 * (0.15 + (0.1 * math.random())) })
table.insert(xform.variations, { name="spherical", weight= sign2 * (0.8 + (0.3*math.random())) })
table.insert(xform.variations, { name="eyefish",   weight= sign3 * (0.5 + (math.random()/2)) })

xform.weight = math.random()*10 + 5
xform.color = 0.1
xform.symmetry = 0.95

affine_scale(xform, 1*math.random())
affine_Prot(xform, math.random()*360)
affine_translate(xform, math.pow(-1, math.random(1,10)) * (0.15 + 0.6*math.random()),
	 			math.pow(-1, math.random(1,10)) * (0.15 + 0.6*math.random()))
--FA.print_items(xform.coefs)
-- affine_Orot(xform, math.random()*360)

flame.scale = 50
flame.gamma = 6
flame.brightness = 10
