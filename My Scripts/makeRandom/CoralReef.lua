--[[
Copyright 2008 Rob Richards

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
//script by Rob Richards
//piritipany.deviantart.com
//based on a script by shortgreenpigg
//shortgreenpigg.deviantart.com ]]

require("Utils")
FA.quality_adjust(3) -- at default preview quality too much noise

local requiredVariations = { "bubble", "pre_blur", "rectangles", "spherical", "julia3D", "pre_rotate_x",
	 					"pre_rotate_y", "ztranslate", "pre_ztranslate", "linear", "curl3D"}

if not variationSet.hasVariations(requiredVariations) then
    if not variationSet.switchToFirstVariationSetWithRequiredVariations(requiredVariations) then
        local uuid = variationSet.makeSetWithVariations(requiredVariations, "CoralReef")
        if uuid and not variationSet.switchToVariationSetWithUuid(uuid) then
            require("Linear")
            return
        end
    end
end

-- the "flame" variable is where the app expects you to store your new fractal - it is Lua table named "flame"
flame = makeBlankFractal(5)

-- First Xform -----------------
local xform = flame.xforms[1]

local b = 0.1 + math.random()*0.1

table.insert(xform.variations, { name="bubble",   weight=b })
table.insert(xform.variations, { name="pre_blur", weight=1 })
if math.random() < 0.3333 then
	local q = 0.25 + math.random()*0.5
	table.insert(xform.variations, { name="rectangles",   weight=0.01, rectangles_x=q, rectangles_y=q })
end	
if math.random() < 0.3333 then
	table.insert(xform.variations, { name="spherical",   weight=b*0.1 })
end	

xform.weight = 0.5
xform.color = math.random()
xform.symmetry = -1

affine_translate(xform, -0.5 + math.random()*1,-0.5 + math.random()*1)
affine_Prot(xform, 360*math.random())

-- 2nd Xform -----------------
xform = flame.xforms[2]

table.insert(xform.variations, { name="julia3D",      weight=0.7, julia3D_power=-2 })
table.insert(xform.variations, { name="pre_rotate_x", weight=0.06 })
table.insert(xform.variations, { name="pre_rotate_y", weight=0.05 })
table.insert(xform.variations, { name="ztranslate",   weight=0.02 })

xform.weight = 1
xform.color = math.random()

affine_translate(xform, -1 + math.random()*2,-1 + math.random()*2)
affine_Prot(xform, 360*math.random())

-- 3rd Xform -----------------
xform = flame.xforms[3]

table.insert(xform.variations, { name="julia3D",        weight=0.5, julia3D_power=2 })
table.insert(xform.variations, { name="pre_rotate_x",   weight=0.1 })
table.insert(xform.variations, { name="pre_rotate_y",   weight=0.2 })
table.insert(xform.variations, { name="pre_ztranslate", weight=0.05 })
table.insert(xform.variations, { name="ztranslate",     weight=-0.05 })

xform.weight = 0.6
xform.color = math.random()

affine_translate(xform, -1 + math.random()*2,-1 + math.random()*2)
affine_Prot(xform, 360*math.random())

-- 4th Xform -----------------
xform = flame.xforms[4]

table.insert(xform.variations, { name="julia3D",        weight=0.935, julia3D_power=2 })
table.insert(xform.variations, { name="pre_ztranslate", weight=0.03 })
table.insert(xform.variations, { name="pre_rotate_x",   weight=0.1 })
table.insert(xform.variations, { name="pre_rotate_y",   weight=0.2 })
table.insert(xform.variations, { name="ztranslate",     weight=-0.05 })

xform.weight = 0.6
xform.color = math.random()

affine_translate(xform, -1 + math.random()*2,-1 + math.random()*2)
affine_Prot(xform, 360*math.random())

-- 5th Xform -----------------
xform = flame.xforms[5]

table.insert(xform.variations, { name="linear",     weight=0.145 })
table.insert(xform.variations, { name="spherical",  weight=0.09 })
table.insert(xform.variations, { name="pre_blur",   weight=1 })

if math.random() < 0.3333 then
	local r = 0.025 + math.random()*0.02
	table.insert(xform.variations, { name="rectangles",   weight=0.3 + math.random()*0.2, rectangles_x=r, rectangles_y=r })
end	

xform.weight = 1
xform.color = math.random()

-- Final Xform --------------------
flame.finalxform = makeBlankFinalXform()  -- the blank fractal does not have a final xform - this creates a blank final xform

table.insert(flame.finalxform.variations, { name="curl3D", weight=1, 
				curl3D_cx=(-0.25 + math.random()*0.5), curl3D_cy=math.random(), curl3D_cz=(-0.1 + math.random()*0.2) })

if math.random() < 0.3333 then
	local r = 0.025 + math.random()*0.02
	table.insert(xform.variations, { name="rectangles",   weight=0.3 + math.random()*0.2, rectangles_x=r, rectangles_y=r })
end	

xform.weight = 1
xform.color = math.random()
xform.symmetry = 1

affine_Prot(xform, 360*math.random())
affine_translate(xform, 0.0,-0.4)

flame.cam_pitch       = 50 + math.random()*20 -- between 50 and 70 degrees
flame.cam_yaw         = math.random()*360; -- randome 360 degrees
flame.cam_perspective = 0.2
flame.scale           = 150 + math.random()*80
flame.brightness      = 10
flame.gamma           = 6

--[[
//script by Rob Richards
//piritipany.deviantart.com
//based on a script by shortgreenpigg
//shortgreenpigg.deviantart.com

Clear;

AddTransform;
with Transform do
begin
 linear3D := 0;
 b := 0.1 + random*0.1;
 bubble := b;
 pre_blur := 1;
// spherical := b*0.1
// rectangles := 0.01
 q := 0.25 + random*0.5
 rectangles_x := q
 rectangles_y := q
 Weight := 0.5;
 color := random
 symmetry := -1
 translate(-0.5 + random*1,-0.5 + random*1)
 rotate(random*360)
end;

Addtransform;
with transform do
begin
 linear3D := 0;
 julia3D := 0.7;
 julia3D_power := -2
 pre_rotate_x := 0.06;
 pre_rotate_y := 0.05;
 ztranslate := 0.02;
 weight := 1.0;
 color := random
 translate(-1 + random*2,-1 + random*2)
 rotate(random*360)
end;

Addtransform;
with transform do
begin
 linear3D := 0;
 julia3D := 0.5;
 julia3D_power := 2
 pre_ztranslate := 0.05;
 pre_rotate_x := 0.1;
 pre_rotate_y := 0.2;
 ztranslate := -0.05;
 weight := 0.6;
 color := random
 translate(-1 + random*2,-1 + random*2)
 rotate(random*360)
end;

Addtransform;
with transform do
begin
 linear3D := 0;
 julia3D := 0.935;
 julia3D_power := 2
 pre_ztranslate := 0.03;
 pre_rotate_x := 0.1;
 pre_rotate_y := 0.2;
 ztranslate := -0.05;
 weight := 0.6;
 color := random
 translate(-1 + random*2,-1 + random*2)
 rotate(random*360)
end;

addtransform;
with transform do
begin
linear3D := 0.145
spherical := 0.09
pre_blur := 1
//rectangles := 0.3 + random*0.2
r := 0.025 + random*0.02
rectangles_x := r
rectangles_c := r
end

SetActiveTransform(transforms);
with Transform do
 begin
 a := 1;
 b := 0;
 c := 0;
 d := 1;
 e := 0;
 f := 0;

 end;

 Transform.curl3D := 1.0;
 transform.curl3D_cx := (-0.25 + random*0.5)
 transform.curl3D_cy := random*1
 transform.curl3D_cz := (-0.1 + random*0.2)
                    
 rotate(random*360)

 Transform.Symmetry := 1;
 Flame.FinalXformEnabled := true;

 Translate(0.0,-0.4)

 Flame.pitch := 0.872664314 + random*0.3490657256; //between 50 and 70 degrees
flame.yaw := random*6.283183061; //randome 360 degrees
Flame.perspective := 0.2;
flame.scale := 20 + random*10
]]