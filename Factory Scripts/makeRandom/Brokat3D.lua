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


-- Adopted from JWildfire's  Brokat3DRandomFlameGenerator.java --------
-- Written by: Andreas Maschke
-- Shortname: Brokat3D
-- Variations Required: curl, juliascope, julia3D, julia3Dz, julian, bubble, pre_blur, post_flatten

local function randomVariation()
    local variations = { "blur3D", "bubble",
        "escher", "rays", "epispiral_wf", "curl3D", "diamond", "juliaq", "julia3Dq", "post_juliaq", "post_julia3Dq",
        "cloverleaf_wf", "disc", "sech", "loonie", "exp", "cosh", "split", "waves2_3D",
        "wedge_sph", "circlize", "heart_wf", "bwraps7", "colorscale_wf", "gdoffs", "taurus", "dc_crackle_wf",
        "mandelbrot", "spirograph", "target", "eclipse", "butterfly3D", "cpow", "pre_subflame_wf",
        "conic", "julia3D", "cell", "dc_hexes_wf", "stripes", "post_mirror_wf", "flipcircle", "waves2_3D", "juliac",
        "colorscale_wf", "crackle", "truchet", "cannabiscurve_wf", "cpow", "subflame_wf", "post_smartcrop",
        "glynnSim3", "flower", "fourth", "heart", "julia3D", "disc2", "polar2", "farblur", "waves3_wf", "waves2b",
        "foci", "scry", "flux", "bwraps7", "splitbrdr", "checks", "colorscale_wf", "falloff2", "sinusoidal3d",
        "cloverleaf_wf", "lazyTravis", "kaleidoscope", "eclipse", "hemisphere", "flipy", "phoenix_julia",
        "popcorn2", "sec", "lazysusan", "sin", "separation", "bi_linear", "hexnix3D", "popcorn2_3D", "julian3Dx",
        "post_mirror_wf", "heart_wf", "mcarpet", "mandelbrot", "cannabiscurve_wf", "colormap_wf", "juliac",
        "rose_wf", "edisc", "blocky", "octagon", "murl", "waves2", "twintrian", "coth", "super_shape", "post_colormap_wf", "waves2_3D",
        "auger", "pre_wave3D_wf", "hexes", "dc_hexes_wf", "barycentroid", "spirograph", "truchet", "epispiral", "waves4_wf",
        "glynnSim2", "tanh", "bipolar", "cot", "horseshoe", "target", "wedge", "unpolar", "pre_boarders2",
        "modulus", "mobius", "bubble2", "bwraps7", "colorscale_wf", "truchet", "collideoscope", "xheart", "waves2b",
        "kaleidoscope", "glynnSim2", "twoface", "cross", "tangent3D", "csc", "curve", "boarders2", "julian3Dx",
        "csch", "bent2", "splits", "julian3Dx", "whorl", "xtrb", "post_mirror_wf", "mandelbrot", "sphericalN", "waves2_3D",
        "cloverleaf_wf", "cannabiscurve_wf", "tan", "blob3D", "julia3D", "hypertile1", "svf", "dc_crackle_wf",
        "log", "cos", "oscilloscope", "wedge_julia", "bwraps7", "heart_wf", "linearT3D", "juliac",
        "hexes", "truchet", "spirograph", "glynnSim3", "pdj", "popcorn", "hypertile2", "waves2_3D",
        "parabola", "rings2", "spherical3D", "spiral", "rectangles", "foci_3D", "sintrange", "waves2b",
        "elliptic", "waves", "swirl", "glynnSim1", "eclipse", "bwraps7", "layered_spiral",
        "heart_wf", "colorscale_wf", "boarders", "secant2", "waffle", "lissajous", "hypertile",
        "circus", "lazyTravis", "ovoid3d", "circleblur", "sineblur", "starblur" };

    local filteredVariations = variationSet.filterVariations(variations)

    local count = #filteredVariations
    return filteredVariations[math.random(count)]
end

local requiredVariations = { "curl", "juliascope", "julia3D", "julia3Dz", "julian", "bubble", "pre_blur", "post_flatten" }

if not variationSet.hasVariations(requiredVariations) then
    if not variationSet.switchToFirstVariationSetWithRequiredVariations(requiredVariations) then
        local uuid = variationSet.makeSetWithVariations(requiredVariations, "Brokat3D")
        if uuid and not variationSet.switchToVariationSetWithUuid(uuid) then
            require("Linear")
            return
        end
    end
end

flame = makeBlankFractal(4)

flame.scale = 200.
flame.zoom = 2. * flame.zoom
flame.rotate = -90
flame.cam_pitch = math.random() * 30.0 + flame.cam_pitch
flame.cam_yaw = math.random() * 30.0 + flame.cam_yaw

-- First xform ----------------------------------
local xform = flame.xforms[1]

xform.weight = 1.5 + math.random()
xform.symmetry = 0.82 + math.random() * 0.16
xform.color = 0.4 + math.random() * 0.2

table.insert(xform.variations, { name="curl", weight=1.6 + math.random() * 0.8,
                                curl_c1 = -1., curl_c2 = 0.001 + math.random() * 0.0199 })

table.insert(xform.variations, { name="post_flatten", weight=.7 })

affine_translate(xform,  1., 0.)
affine_Prot(xform, 180.0);

flame.xaos[1][1] = 0.0
flame.xaos[1][2] = 1.0
flame.xaos[1][3] = 0.0
flame.xaos[1][4] = 0.0

-- Second xform ----------------------------------
xform = flame.xforms[2]

xform.weight = 0.05 + math.random() * 0.35
xform.color = 0.5 + math.random() * 0.5
xform.symmetry = 0.5

if variationSet.is3D then
    fncNames = { "juliascope", "julia3D", "julia3Dz", "julian" }
else
    fncNames = { "juliascope", "julian" }
end
local variation = {}

variation.name = fncNames[math.random(#fncNames)]
local power = 1
if math.random() < 0.33 then
	power = 2
elseif math.random() < 0.5 then
	power = 3
else
	power = 4
end

variation[variation.name .. "_power"] = power
variation.weight = 1
xform.variations[1] = variation

if variationSet.variationIs2D(variation.name) then
    table.insert(xform.variations, { name="post_flatten", weight=.7 })
end

flame.xaos[2][1] = 1.0
flame.xaos[2][2] = 0.0
flame.xaos[2][3] = 1.0
flame.xaos[2][4] = 1.0

--  third xform -----------------------------------------
xform = flame.xforms[3]

xform.weight = 0.4 + math.random() * 0.2
xform.color = 0.1 + math.random() * 0.3
xform.symmetry = 0.

variation = {}
if math.random() < 0.33 then
	variation.name = "bubble"
else
	variation.name = randomVariation()
end
variation.weight = 0.01 + math.random() * 0.04
xform.variations[1] = variation

if variationSet.variationIs2D(variation.name) then
    table.insert(xform.variations, { name="post_flatten", weight=.7 })
end

table.insert(xform.variations, { name="pre_blur", weight=5.0 + math.random() * 10.0 })

affine_translate(xform,  -1., 0.)

flame.xaos[3][1] = 1.0
flame.xaos[3][2] = 1.0
flame.xaos[3][3] = 0.0
flame.xaos[3][4] = 0.0


--  4th xform -----------------------------------------
xform = flame.xforms[4]

xform.weight = 0.4 + math.random() * 0.2
xform.color = 0.1 + math.random() * 0.3
xform.symmetry = 0.

variation = {}
variation.name = randomVariation()
variation.weight = 0.01 + math.random() * 0.04
xform.variations[1] = variation

if variationSet.variationIs2D(variation.name) then
    table.insert(xform.variations, { name="post_flatten", weight=.7 })
end

affine_Prot(xform, math.random() * 360.0);
affine_scale(xform, 1.1 + math.random() * 3.0)

flame.xaos[4][1] = 1.0
flame.xaos[4][2] = 1.0
flame.xaos[4][3] = 1.0
flame.xaos[4][4] = 1.0
