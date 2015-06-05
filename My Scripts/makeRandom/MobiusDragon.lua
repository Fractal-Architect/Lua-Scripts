
--[[
 Copyright 2015 Steven Brodhead, Sr., Centcom Inc.
 
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
//Mobius Dragon script by penny5775
//Uses the mobius variation probably -
//with variablse Re_A, Im A, Re B, ... Im D.

//Many thanks to n8tiveattitude1, l33tmobil3, and loonyl for their
//input, innovation, and help with this style.

//This script makes a very basic Mobius Dragon.
//You will want to adjust weights, symmetry,
//variations, and sometimes positioning on
//transforms 5 - 7.
//You may adjust the position of transform 1 or 2 if
//you make the same change to both of them.
//Or you may use the companion script to alter
//both of them and adjust all other positions as
//well.
--]]

require("Utils")

local requiredVariations = { "mobius", "linear"  }

if not variationSet.hasVariations(requiredVariations) then
    if not variationSet.switchToFirstVariationSetWithRequiredVariations(requiredVariations) then
        local uuid = variationSet.makeSetWithVariations(requiredVariations, "MobiusDragon")
        if uuid and not variationSet.switchToVariationSetWithUuid(uuid) then
            require("Linear")
            return
        end
    end
end

local flamepackX = { 0.01784, 0.0226, 0.02898, 0.0378, 0.0502, 0.06741, 0.0909, 0.1223, 0.1648, 0.2252, 0.3195, 0.4995 }
local flamepackY = { 0.05323, 0.0613, 0.071,   0.0828, 0.0969, 0.11389, 0.1339, 0.1589, 0.1939, 0.2512, 0.3668, 0.6772 }

-- the "flame" variable is where the app expects you to store your new fractal - it is Lua table named "flame"
flame = makeBlankFractal(7)

local ranx, rany

if math.random() < 0.5 then
    ranx = math.random()/10.*1.2
    rany = math.random()/10.*1.2
else
    local index = math.random(1, 12)
    ranx = flamepackX[index]
    rany = flamepackY[index]
end


flame.y = rany/2
flame.x = 0
flame.scale = 200
flame.brightness = 8

-- First Xform -----------------
local xform = flame.xforms[1]

xform.weight = 1.
xform.symmetry = 0.8

xform.coefs:E(ranx)
xform.coefs:F(-rany)

table.insert(xform.variations, { name="mobius", weight = 1.,
                                 mobius_re_a = 1.,
                                 mobius_re_b = 0.,
                                 mobius_re_c = 0.,
                                 mobius_re_d = 1.,
                                 mobius_im_a = 0.,
                                 mobius_im_b = 0.,
                                 mobius_im_c = -1.,
                                 mobius_im_d = 0.  })

-- 2nd Xform -----------------
xform = flame.xforms[2]

xform.weight = 1.
xform.symmetry = 0.8

table.insert(xform.variations, { name="linear", weight = 1 })

xform.coefs:E(ranx)
xform.coefs:F(-rany)
xform.post:A(-1.)
xform.post:B(0.)
xform.post:C(0.)
xform.post:D(-1.)
                            
-- 3rd Xform -----------------
xform = flame.xforms[3]

xform.weight = 1.
xform.symmetry = 1.

xform.coefs:E(-1.)

table.insert(xform.variations, { name="linear", weight = 1 })

-- 4th Xform -----------------
xform = flame.xforms[4]

xform.weight = 1.
xform.symmetry = 1.

xform.coefs:E(1.)

table.insert(xform.variations, { name="linear", weight = 1 })

-- 5th Xform -----------------
xform = flame.xforms[5]

xform.weight = 0.0625

table.insert(xform.variations, { name="linear", weight = 1 })

xform.coefs:F(-3.)
xform.post:E(-ranx)
xform.post:F(-rany)

-- 6th Xform -----------------
xform = flame.xforms[6]

xform.weight = 0.0625
xform.color = math.random()

table.insert(xform.variations, { name="linear", weight = 1 })

-- xform.post:D(0.001)    -- removing this cleans up the horizontal lines
xform.post:E(-ranx)
xform.post:F(1. - rany)

-- 7th Xform -----------------
xform = flame.xforms[7]

xform.weight = 0.0625
xform.color = math.random()

variation = {}
variation.name = random_variation()
variation.weight = 0.01 + 0.1 * math.random()
xform.variations[1] = variation

xform.post:E(0.5 - (ranx/2))
xform.post:F(-(rany/2))

