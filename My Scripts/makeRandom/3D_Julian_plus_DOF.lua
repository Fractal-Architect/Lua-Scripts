--[[
Copyright 2008 kuzy62.deviantart.com

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
{3D_Julian_DOF_by_kuzy62_final}
{Designed by kuzy62}
{kuzy62.deviantart.com}
{based on 3D Julian Tutorial by Meckie}
{Meckie.deviantart.com}
]]

require("Utils")
FA.quality_adjust(3) -- at default preview quality too much noise

local requiredVariations = { "spherical", "julian", "hemisphere", "pre_blur", "ztranslate", "zcone", "zscale", "post_flatten"}

if not variationSet.hasVariations(requiredVariations) then
    if not variationSet.switchToFirstVariationSetWithRequiredVariations(requiredVariations) then
        local uuid = variationSet.makeSetWithVariations(requiredVariations, "3D Julian plus DOF")
        if uuid and not variationSet.switchToVariationSetWithUuid(uuid) then
            require("Linear")
            return
        end
    end
end

-- the "flame" variable is where the app expects you to store your new fractal - it is Lua table named "flame"
flame = makeBlankFractal(2)

-- First Xform -----------------
local xform = flame.xforms[1]

local sign = math.pow(-1, math.random(1,2))

table.insert(xform.variations, { name="spherical",    weight=math.random()*0.05 })
table.insert(xform.variations, { name="julian",       weight=1.2 + math.random(), 
													julian_power = 2. + sign*math.random()*.5, julian_dist = -1 + sign*math.random()*.2 })
table.insert(xform.variations, { name="zscale",       weight=0.7 +math.random()*0.125 })
table.insert(xform.variations, { name="zcone",        weight=-0.01 })
table.insert(xform.variations, { name="ztranslate",   weight=0.1*math.random() })
table.insert(xform.variations, { name="zcone",        weight=-0.01 })
table.insert(xform.variations, { name="post_flatten", weight=0.7 })


xform.weight = 1.35 + math.random()
xform.color = math.random()*0.5
xform.symmetry = 0.5 +math.random()*0.2

-- affine_scale(xform, 0.333 +math.random()*0.25)
affine_scale(xform, 2 + math.random()*2)
affine_translate(xform, -math.random()*0.4,math.random()*0.4)
affine_rotate(xform, 189*math.random())

-- 2nd Xform -----------------
xform = flame.xforms[2]

table.insert(xform.variations, { name="hemisphere",  weight=0.33 +math.random()*0.25 })
table.insert(xform.variations, { name="pre_blur",    weight=2.5 +math.random() })
table.insert(xform.variations, { name="zscale",      weight=0.1 })
table.insert(xform.variations, { name="zcone",       weight=-0.01 })
table.insert(xform.variations, { name="ztranslate",  weight=0.1*math.random() })
table.insert(xform.variations, { name="post_flatten", weight=0.5 })

xform.weight = 0.5 + math.random()*0.5
xform.color = math.random()*0.25
xform.symmetry = -0.75 + math.random()*0.25

affine_scale(xform, 0.333 - math.random()*0.25)
affine_translate(xform, math.random()*0.4, math.random()*0.4)
affine_rotate(xform, 90*math.random())

flame.brightness = 6.5
flame.gamma = 3.8
flame.width = 400
flame.height = 300
flame.centre_x = 0
flame.centre_y = -.3
flame.scale = 200
flame.cam_pitch = 50 + math.random()*20;
flame.cam_yaw = math.random()*360;
flame.cam_perspective = 0.2;
-- flame.cam_dof = 0.15;


--[[
{3D_Julian_DOF_by_kuzy62_final}
{Designed by kuzy62}
{kuzy62.deviantart.com}
{based on 3D Julian Tutorial by Meckie}
{Meckie.deviantart.com}

 //Clears flame

Clear;

  AddTransform;        //Transform 1 Julian //
  With Transform do
  Begin
    linear3D:=0;
    linear:=0;
    spherical:=0.05*random;
    julian:=1.2+random;
    julian_power:= 2 + random;
    julian_dist:=-1;
    scale(0.333 +random*0.25);
    translate(-random*0.4,random*0.4);
    rotate (random*189);
    zscale:=0.7 +random*0.125;
    zcone:=-0.01;
    ztranslate:=random*0.1;
    weight:=1.35 + random;
    symmetry:=0.5 +random*0.2;
    color:=random*0.5;
  end

AddTransform;          //Transfrom 2 hemisphere and pre-blur for solidness//
  With Transform do
  Begin
    linear3D:=0;
    linear:=0;
    hemisphere:= 0.333 + random*0.25;
    pre_blur:=2.5 + random;
    scale(0.333 - random*0.25);
    zscale:=0.1;
    zcone:=-0.01;
    ztranslate:=random*0.1;
    translate(random*0.4,random*0.4);
    rotate (random*90);
    weight:=0.5 +random*0.5;
    symmetry:=-0.75 + random*0.25;
    color:=random*0.25;
  end

For i := 0 to 255 do
Begin
    For j := 0 to 2 do
    Begin
        Flame.Gradient[i][j] := trunc(31+random*199) ;
    End
End

{-----------------------------------------------------------------------------}

Flame.gamma := 3.8;
Flame.x := 0;
Flame.y := 0.2;
Flame.scale := 20;
Flame.pitch := 0.8772664314 + random*0.3490657256; //between 50 and 70 degrees
flame.yaw := random*6.283183061; //randome 360 degrees
Flame.perspective := 0.2;
//Flame.DOF := 0.15;
CalculateScale;
ResetLocation := true;]]