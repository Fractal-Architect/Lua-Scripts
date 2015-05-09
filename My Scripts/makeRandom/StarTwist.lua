--[[
Copyright 2007 Daniel Eaton

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
{ ===================================== }
{ "Technica - Sinusoidal"               }
{  Variation By Roz Rayner-Rix          }
{                                       }
{ Originally Scripted By Thomas Desloges}
{ http://cabintom.deviantart.com/       }
{                                       }
{ With the help of Tracey               }
{ http://tdierikx.deviantart.com/       }
{ ===================================== }
]]

require("Utils")

-- Variations Required: cylinder, juliascope,julian

local requiredVariations = { "cylinder", "juliascope", "julian" }

-- if the current variation set does not support these, create a linear random fractal instead --
if not variationSet.hasVariations(requiredVariations) then
    variationSet.switchToVariationSetWithName("Flam3 Legacy")
end

local sd = 0.35 + 0.65 * math.random()
local sj = 0.25 + 0.75 * math.random()
local wd = 1.   + 4.   * math.random()
local wj = 0.1  + 1.9  * math.random()

flame = makeBlankFractal(2)

-- First Xform -----------------
local xform = flame.xforms[1]

table.insert(xform.variations, { name="cylinder", weight=0.852 })

xform.weight = wd
xform.color = math.random()

affine_scale(xform, sd)
affine_Prot(xform, 360 * math.random());

-- 2nd Xform -----------------
xform = flame.xforms[2]

table.insert(xform.variations, { name="juliascope", weight=3.296, juliascope_power = 41, juliascope_dist = -8.17714 })

xform.weight = wj
xform.color = math.random()

affine_scale(xform, sj)
affine_Prot(xform, 360 * math.random());

-- Final Xform -----------------
flame.finalxform = makeBlankFinalXform()

table.insert(flame.finalxform.variations, { name="julian", weight=1.266, julian_power = 3, julian_dist = 1 })

flame.scale = 92.25
flame.brightness = 10
flame.gamma = 2.5
flame.width = 400
flame.height = 253


