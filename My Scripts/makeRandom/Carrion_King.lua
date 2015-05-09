--[[
Copyright 2008 Daniel Eaton

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

-- Written by: Daniel Eaton  djeaton3162.deviantart.com  for Apophysis
-- Ported to Lua by Steven Brodhead, Sr.

requiredVariations = { "linear", "sinusoidal", "juliascope" }

-- if the current variation set does not support these, switch to Flam3 Legacy variation set --
if not variationSet.hasVariations(requiredVariations) then
    variationSet.switchToVariationSetWithName("Flam3 Legacy")
end

-- the "flame" variable is where the app expects you to store your new fractal - it is Lua table named "flame"
flame = makeBlankFractal(2)   -- creates a blank fractal with 2 Xforms (creates normal Xaos from/to matrix as well )

local randomx  =  1. + 0.08 * math.random()  -- randomx := (1+(random*0.08))

-- First Xform -----------------
-- xform is a local variable that points to the first xform in the flame variable - it reduces typing below
local xform = flame.xforms[1]           -- AddTransform
                                        -- with Transform do
                                        -- begin
-- we create an empty variation table, describe the variation, the add it as the first variation owned by the xform
local variation = {}                                                       
variation.name = "linear"                -- Transform.linear := 1;
variation.weight = 1                     -- Transform.linear := 1;
xform.variations[1] = variation	

xform.weight = 1                         -- Transform.weight := 1;
xform.color = math.random()              -- Transform.color := random;

-- I think these numbers were copied from his Triangle editor matrix values and simply multiplied by the randomx random number
xform.coefs[1][1] = -0.705641*randomx    -- Transform.A := (-0.705641*randomx);
xform.coefs[1][2] = -0.66265*randomx     -- Transform.B := (-0.66265*randomx);
xform.coefs[2][1] = -0.66265*randomx     -- Transform.C := (-0.66265*randomx);
xform.coefs[2][2] =  0.705641*randomx    -- Transform.D := (0.705641*randomx);
xform.coefs[3][1] =  0.3442*randomx      -- Transform.E := (0.3442*randomx);
xform.coefs[3][2] = -0.378852*randomx    -- Transform.F := (-0.378852*randomx);


randomx  =  1. + 0.08 * math.random()    -- randomx := (1+(random*0.08))

-- 2nd Xform -----------------
xform = flame.xforms[2]                  -- AddTransform
                                         -- with Transform do
                                         -- begin
variation = {}
variation.name = "linear"                -- Transform.linear := 1;
variation.weight = 1                     -- Transform.linear := 1;

xform.variations[1] = variation	

variation = {}
variation.name = "sinusoidal"            -- Transform.sinusoidal := 0.1*randomx;
variation.weight = 0.1*randomx           -- Transform.sinusoidal := 0.1*randomx;

-- this xform has 2 variations - here we add the second one to the xform
xform.variations[2] = variation	

xform.coefs[1][1] = -0.255826*randomx    -- Transform.A := (-0.255826*randomx);
xform.coefs[1][2] =  0.215753*randomx    -- Transform.B := (0.215753*randomx);
xform.coefs[2][1] = -0.178353*randomx    -- Transform.C := (-0.178353*randomx);
xform.coefs[2][2] = -0.229212*randomx    -- Transform.D := (-0.229212*randomx);
xform.coefs[3][1] =  0.605831*randomx    -- Transform.E := (0.605831*randomx);
xform.coefs[3][2] = -0.653439*randomx    -- Transform.F := (-0.653439*randomx);

xform.weight = 0.4                       -- Transform.weight := 0.4;
xform.color = math.random()              -- Transform.color := random;


randomx  =  1. + 0.08 * math.random()    -- randomx := (1+(random*0.08))

-- Final Xform -----------------
flame.finalxform = makeBlankFinalXform()  -- the blank fractal does not have a final xform - this creates a blank final xform
-- this also does this:                                Flame.FinalXformEnabled := true;

variation = {}
-- In Apophysis, the new xform already has linear set, this turns it off:      Transform.linear := 0;
variation.name = "juliascope"                       -- Transform.juliascope := 1*randomx;
variation.weight = 1*randomx                        -- Transform.juliascope := 1*randomx;
variation.juliascope_power = -2*math.random()       -- Transform.juliascope_power := -2*random;
variation.juliascope_dist = 2.1*math.random()       -- Transform.juliascope_dist := 2.1*random;

flame.finalxform.variations[1] = variation

flame.finalxform.color = math.random()              -- Transform.color := random;
-- this symmetry setting blends final xform color with the normal xform's color
-- the default symmetry = 1 for final xform, normally has the final xform not affecting the output color
flame.finalxform.symmetry = 0                       -- Transform.Symmetry := 0;


flame.finalxform.coefs[1][1] = 0                    -- Transform.A := 0;
flame.finalxform.coefs[1][2] =  0.666667*randomx    -- Transform.B := (0.0.666667*randomx);
flame.finalxform.coefs[2][1] = -0.666667*randomx    -- Transform.C := (-0.666667*randomx);
flame.finalxform.coefs[2][2] = 0                    -- Transform.D := 0;
flame.finalxform.coefs[3][1] =  0.050472*randomx    -- Transform.E := (0.050472*randomx);
flame.finalxform.coefs[3][2] =  0.011575*randomx    -- Transform.F := (0.011575*randomx);



-- This is not needed with FA:   ResetLocation := True;
--                               Flame.vibrancy := 1;    that is the FA default vibrancy

flame.scale = 100          -- Parameter_Scale := 10;
flame.brightness = 10      -- Flame.brightness := 35;
flame.gamma = 2            -- Flame.gamma := 2;

-- this only tells FA what the fractal aspect ration (width/height) is - it resizes the actual fractal to the output window size
flame.width = 400           -- I think  400/253 is the default Apophysis aspect ration (for Flam3 it is 4/3)
flame.height = 253

-- This is not needed with FA:   CalculateBounds;
--                               UpdateFlame := True;

--[[
//Concatenation Script                                     
Clear;

randomx := (1+(random*0.08))

//First Transform
AddTransform
with Transform do
begin
  Transform.weight := 1;
  Transform.color := random;
  Transform.linear := 1;
  Transform.A := (-0.705641*randomx);
  Transform.B := (-0.66265*randomx);
  Transform.C := (-0.66265*randomx);
  Transform.D := (0.705641*randomx);
  Transform.E := (0.3442*randomx);
  Transform.F := (-0.378852*randomx);
end;


randomx := (1+(random*0.08))
//second transform
AddTransform
with Transform do
begin
  Transform.linear := 1;
  Transform.weight := 0.4;
  Transform.color := random;
  Transform.sinusoidal := 0.1*randomx;
  Transform.A := (-0.255826*randomx);
  Transform.C := (0.215753*randomx);
  Transform.B := (-0.178353*randomx);
  Transform.D := (-0.229212*randomx);
  Transform.E := (0.605831*randomx);
  Transform.F := (-0.653439*randomx);
end;


randomx := (1+(random*0.08))
//Add final transform
SetActiveTransform(transforms);
with Transform do
begin
 Transform.linear := 0;
 Transform.juliascope := 1*randomx;
 Transform.color := random;
 Transform.juliascope_power := -2*random;
 Transform.juliascope_dist := 2.1*random;
 Transform.Symmetry := 0;
 Transform.A := (0);
 Transform.C := (-0.666667*randomx);
 Transform.B := (0.666667*randomx);
 Transform.D := (0);
 Transform.E := (0.050472*randomx);
 Transform.F := (0.011575*randomx);
 Flame.FinalXformEnabled := true;
end;


ResetLocation := True;
Parameter_Scale := 10;
Flame.brightness := 10;
Flame.vibrancy := 1;
Flame.gamma := 2;
CalculateBounds;
UpdateFlame := True;
                     
--]]         