
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

local index = #flame.xforms + 1
local ranx = math.random()/10.*1.2
local rany = math.random()/10.*1.2
local xOffset1 =  4. + math.random()
local xOffset2 = -3.

flame.y = rany/2
flame.x = 0
flame.scale = 40

-- 2nd Xform -----------------
local xform = makeBlankXform()

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
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 1.
xform.symmetry = 1.

xform.coefs:E(-xOffset1)

table.insert(xform.variations, { name="linear", weight = 1 })

-- 4th Xform -----------------
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 1.
xform.symmetry = 1.

xform.coefs:E(xOffset1)

table.insert(xform.variations, { name="linear", weight = 1 })

-- 5th Xform -----------------
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 0.0625

table.insert(xform.variations, { name="linear", weight = 1 })

-- xform.coefs:F(xOffset2)
xform.post:E(-ranx)
xform.post:F(-rany)

-- 6th Xform -----------------
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 0.0625
xform.color = math.random()

table.insert(xform.variations, { name="linear", weight = 1 })

-- xform.post:D(0.001)    -- removing this cleans up the horizontal lines
xform.post:E(-ranx)
xform.post:F(1. - rany)
