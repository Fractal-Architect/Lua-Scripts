
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

require("Utils")

local requiredVariations = { "splits", "julian", "linear", "csch"  }

-- if the current variation set does not support these, create a linear random fractal instead --
if not variationSet.hasVariations(requiredVariations) then
    variationSet.switchToVariationSetWithName("Flam3 Legacy")
end


flame = makeBlankFractal(3)

-- First Xform -----------------
local xform = flame.xforms[1]

xform.weight = randInRange(0.00001, 2.)
xform.color  = math.random()

if math.random() < 0.5 then
    -- make sure there is a Pre Variation group
    if #xform.preVarGroups == 0 then
        table.insert(xform.preVarGroups, {})
    end    
    table.insert(xform.preVarGroups[1], { name="splits", weight=-0.5 + 0.2 * math.random(),
                                          splits_x = randInRange(-2, 2), splits_y = randInRange(-2, 2) })
end

table.insert(xform.variations, { name="julian", weight = randInRange(-2., 2.),
                                 julian_power = math.random(1, 2), julian_dist = randInRange(-2., 2.) })

randomPreMatrix(xform)

-- 2nd Xform -----------------
xform = flame.xforms[2]

table.insert(xform.variations, { name="julian", weight = randInRange(-2., 2.),
                                 julian_power = math.random(1, 2), julian_dist = randInRange(-2., 2.) })

if math.random() < 0.8 then
    -- make sure there is a Post Variation group
    if #xform.postVarGroups == 0 then
        table.insert(xform.postVarGroups, {})
    end    
    table.insert(xform.postVarGroups[1], { name="linear", weight=randInRange(-1., 1.) })
    table.insert(xform.postVarGroups[1], { name="csch",   weight=randInRange(-1., 1.) })
end
                            
xform.weight = randInRange(0.00001, 2.)
xform.color = math.random()

randomPreMatrix(xform)

-- 3rd Xform -----------------
xform = flame.xforms[3]

table.insert(xform.variations, { name="julian", weight = randInRange(-2., 2.),
                                 julian_power = math.random(1, 2), julian_dist = randInRange(-2., 2.) })

                            
xform.weight = randInRange(0.00001, 2.)
xform.color = math.random()

randomPreMatrix(xform)
randomPostMatrix(xform)
