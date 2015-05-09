require("Utils")

--[[
  JWildfire - an image and animation processor written in Java
  Copyright (C) 1995-2011 Andreas Maschke
  Copyright (C) 2014 Steve Brodhead Sr. (translated from Java to Lua)

  This is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser 
  General Public License as published by the Free Software Foundation; either version 2.1 of the 
  License, or (at your option) any later version.
 
  This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without 
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this software; 
  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  02110-1301 USA, or see the FSF site: http://www.fsf.org.
--]]


-- Adopted from JWildfire's  Flowers3DRandomFlameGenerator.java --------
-- Written by: Andreas Maschke
-- Shortname: Flowers3D
-- Variations Required: curl, juliascope, julia3D, julia3Dz, julian, bubble, pre_blur


local requiredVariations = { "gaussian_blur", "linear", "linearT3D", "spherical", "zcone", "cross", "epispiral_wf",
	"epispiral", "blob3D", "blur3d", "ztranslate", "julia3D" }

-- if the current variation set does not support these, create a linear random fractal instead --
if not variationSet.hasVariations(requiredVariations) then
    if not variationSet.switchToFirstVariationSetWithRequiredVariations(requiredVariations) then
        local uuid = variationSet.makeSetWithVariations(requiredVariations, "Flowers3D")
        if uuid and not variationSet.switchToVariationSetWithUuid(uuid) then
            require("Linear")
            return
        end
    end
end
FA.quality_adjust(2)

flame = makeBlankFractal(4)

flame.scale = 200.
flame.cam_pitch = 49.
flame.cam_yaw = 12.
flame.centre_y = -0.0431356
flame.width  = 400
flame.height = 300

-- First xform ----------------------------------
local xform = flame.xforms[1]

xform.weight = 0.5 + math.random()
xform.symmetry = 0
xform.color = 0
xform.opacity = 0.3333

table.insert(xform.variations, { name="gaussian_blur", weight=0.5 })

-- Second xform ----------------------------------
xform = flame.xforms[2]

xform.weight = 3.0 + math.random() * 10.0
xform.color = math.random()
xform.symmetry = math.random()

local variation = {}
if math.random() < 0.33 then
	variation.name = "linear"
	variation.weight = 1	
else
	x = 2.0 * math.random() - 0.5
	variation.name = "linearT3D"
	variation.weight = 1
	variation.linearT3D_powX = x
	variation.linearT3D_powY = x
	variation.linearT3D_powZ = 2.0 * math.random() - 0.5
end
xform.variations[1] = variation

table.insert(xform.variations, { name="spherical", weight=0.1 + math.random() * 0.3 })
table.insert(xform.variations, { name="zcone",     weight=0.2 + math.random() * 0.9 })
table.insert(xform.variations, { name="cross",     weight=0.01 + 0.045 * math.random() })

if math.random() < 0.33 then
    table.insert(xform.variations, { name="epispiral_wf", weight=0.02 + 0.29 * math.random(),
        epispiral_wf_waves = 3 + math.floor(math.random() * 10.0) })
	if math.random() < 0.33 then
        table.insert(xform.variations, { name="epispiral", weight=0.01 + 0.14 * math.random(),
            epispiral_thickness = 0.05 + math.random() * 0.15, epispiral_n = 3.0 + math.random() * 10.0 })
	end
end

affine_scale(xform,  1.0 + (0.1 - math.random() * 0.2))
affine_Prot(xform, 45.0 - math.random() * 90.0)
affine_translate(xform,  0.01 - 0.02 * math.random(), 0.01 - 0.02 * math.random())


--  third xform -----------------------------------------
local advStructure = math.random() > 0.25

if advStructure then
	xform = flame.xforms[3]

	xform.weight = 1.0 + math.random() * 0.3
	xform.color = 0
	xform.symmetry = 1.
    xform.opacity = 0.3

    table.insert(xform.variations, { name="blob3D", weight=0.05, blob3D_low = 0.1, blob3D_high = 0.3, blob3D_waves = 9 })
else
	flame.xforms[3] = nil
end


--  4th xform -----------------------------------------
if advStructure then
	xform = flame.xforms[4]

	xform.weight = 0.1 + math.random() * 0.3
	xform.color = 0
	xform.symmetry = 1

    table.insert(xform.variations, { name="blur3d", weight=0.05 })
    table.insert(xform.variations, { name="ztranslate", weight=15 })
else
	flame.xforms[4] = nil
	flame.xaos = makeNormalXaos(2)
end


local finalxform = makeBlankFinalXform()

local power = -2.0
if math.random() < 0.25 then
  power = power - math.random() * 4.0
end

table.insert(finalxform.variations, { name="julia3D", weight=2.0 + (1.0 - 2.0 * math.random()), julia3D_power = power })

flame.finalxform = finalxform
