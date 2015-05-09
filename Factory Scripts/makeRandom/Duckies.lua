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

-- Adopted from JWildfire's  DuckiesRandomFlameGenerator.java --------
-- Written by: Andreas Maschke
-- Shortname: Duckies
-- Variations Required: spherical, juliascope, julian

local requiredVariations = { "spherical", "juliascope", "julian" }

-- if the current variation set does not support these, switch to Flam3 Legacy variation set --
if not variationSet.hasVariations(requiredVariations) then
    variationSet.switchToVariationSetWithName("Flam3 Legacy")
end

local xformCount = 2
if math.random() > 0.667 then
	if math.random() > 0.667 then
		xformCount = 4
	else
		xformCount = 3
	end
else
	xformCount = 2
end

flame = makeBlankFractal(xformCount)

-- First xform ----------------------------------
local xform = flame.xforms[1]

xform.weight = 0.5 + math.random()
xform.symmetry = -0.5
xform.color = math.random()

local variation = {}
if math.random() < 0.12 then
	variation.name = random_variation()
else
	variation.name = "spherical"
end
variation.weight = 1.5 + math.random()
xform.variations[1] = variation

affine_translate(xform,  0.75 - 5.5 * math.random(),  0.75 - 5.5 * math.random())
affine_Prot(xform, -60. + math.random() * 30.0);
affine_scale(xform, 0.1 + math.random() * 0.4)

-- Second xform ----------------------------------
xform = flame.xforms[2]

xform.weight = 1. + math.random() * 100.
xform.color = math.random()

variation = {}
if math.random() < 0.8 then
	variation.name = "juliascope"
	if math.random() < 0.8 then
		variation.juliascope_power = 2.
		variation.juliascope_dist  = 1.
	else
		variation.juliascope_power = 2. + math.random() * 10.0
		variation.juliascope_dist  = -2.0 + 4.0 * math.random()
	end
else
	variation.name = "julian"
	if math.random() < 0.8 then
		variation.julian_power = 2.
		variation.julian_dist  = 1.
	else
		variation.julian_power = 2. + math.random() * 10.0
		variation.julian_dist  = -2.0 + 4.0 * math.random()
	end
end
variation.weight = 1.5 + math.random()
xform.variations[1] = variation

affine_Prot(xform, math.random() * 360.0);
affine_translate(xform,  1.75 - 3.50 * math.random(), 0.75 - 5.50 * math.random())
affine_scale(xform, 1.1 + math.random() * 2.0)

-- flame.xaos[1][1] = 0.0
-- flame.xaos[1][2] = 1.0

-- Random third xform -----------------------------------------
if xformCount >= 3 then
	xform = flame.xforms[3]

	xform.weight = 1.0 + math.random() * 100.0
	xform.color = math.random()
	
	variation = {}
	variation.name = random_variation()
	variation.weight = 0.25 + 1.25 * math.random()
	xform.variations[1] = variation

	affine_Prot(xform, -12.0 + math.random() * 24.0);
	affine_translate(xform,  -0.125 + math.random() * 0.25, -0.125 + math.random() * 0.25)
	affine_scale(xform, 0.9 + math.random() * 0.2)

    -- flame.xaos[1][2] = 0.0
    -- flame.xaos[2][3] = 0.0
    -- flame.xaos[3][3] = 0.0
end

if xformCount == 4 then
	xform = flame.xforms[4]

	xform.weight = 0.50 + math.random() * 50.0
	xform.color = math.random()
	variation = {}
	variation.name = random_variation()
	variation.weight = 0.125 + 0.75 * math.random()
	xform.variations[1] = variation

	affine_Prot(xform,       -24.0 + math.random() * 48.0);
	affine_translate(xform,  -0.25 + math.random() * 0.5, -0.25 + math.random() * 0.5)
	affine_scale(xform,      0.5 + math.random() * 0.25)

    -- flame.xaos[1][3] = 0.0
    -- flame.xaos[3][3] = 0.0
    -- flame.xaos[2][4] = 0.0
    -- flame.xaos[3][4] = 0.0
    -- flame.xaos[4][4] = 0.0
end
