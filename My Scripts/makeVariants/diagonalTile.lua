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
local xOffset = 2.5 + math.random()
local yOffset = xOffset

flame.scale = 40
flame.brightness = 12
                            
-- 3rd Xform -----------------
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 2.
xform.color = math.random()
xform.color_speed = 1.

xform.coefs:E(-xOffset)
xform.coefs:F(-yOffset)

table.insert(xform.variations, { name="linear", weight = 1 })

-- 4th Xform -----------------
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 2.
xform.color = math.random()
xform.color_speed = 1.

xform.coefs:E(xOffset)
xform.coefs:F(yOffset)

table.insert(xform.variations, { name="linear", weight = 1 })

-- 5th Xform -----------------
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 2.
xform.color = math.random()
xform.color_speed = 1.

table.insert(xform.variations, { name="linear", weight = 1 })

xform.coefs:E(-xOffset)
xform.coefs:F(yOffset)

-- 6th Xform -----------------
xform = makeBlankXform()
table.insert(flame.xforms, xform)

xform.weight = 2.
xform.color = math.random()
xform.color_speed = 1.

table.insert(xform.variations, { name="linear", weight = 1 })

xform.coefs:E(xOffset)
xform.coefs:F(-yOffset)
