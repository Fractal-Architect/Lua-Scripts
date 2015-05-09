--[[

NAME: simil4.lua

TYPE: Lua script for Oxidizer http://oxidizer.sourceforge.net/

DEPENDENCIES: None.

DISCLAIMER:
This software is freeware. It comes without any warranty
and you may redistribute and modify it.

Written by Ralf Flicker, August 2008 (homepage.mac.com/rflicker)
Last revision 2008-12-08

DESCRIPTION: Batch generation of random genomes by similarity transforms.
This script is a generalization of "simil3.lua" adding keywords for greater
user control and the ability to override randomization of parameters that
you want to keep fixed. 

For better consistency with Oxidizer and other literature, some parameters
have been renamed. "Shift" is now called "move"; "transpose" is now called
"reflection"; and the "constrain" mode is now called "lock". 

PARAMETERS:

Global parameters:
------------------
nbat          number of genomes to create
qual          rendering quality
erad          estimator radius (set to 0 to turn off smoothing)
vamp          amplitude range (+/-) for variation weight
gsym          genome symmetry (2-element table of integers)
bias          symmetry bias (between 0-1)
color         xform color mode ('ran' or 'lin')

Note about "bias" parameters:

The bias parameters can be used to weigh the dice or tune the randomziation
process, making a certain outcome more likely. Hence, bias=1 here means *no*
tuning, the default setting, while bias<1 (but positive) means making the 
outcome 0 more likely.

This method can only bias towards 0. To instead bias away from 0 in the
transformations, use the list mode (mode=1) and populate it with the
distribution of numbers that you want to randomize from. To make a specific
number more probable, enter it multiple times into the list.

The genome symmetry "gsym" is randomized within the range of the table given.
For instance gsym={-4,6} will randomize the symmetry between -4 and 6. Setting
both elements to the same value will fix the symmetry to this value. The bias
(default to 1) can be used to increase the probability of getting zero symmetry
by lowering the value from 1 towards 0.

The color mode can be either 'ran' (randomized) or 'lin' (the xform colors are
linearly distributed across the color map).


Transform parameters:
--------------------
rot.mode      rotation mode [0,1,2,3]
rot.lock      rotation lock [0,1]
rot.bias      rotation bias (real number between 0-1)
rot.list      rotation list (table of real numbers)
rot.range     rotation range (2-element table of real numbers)
rot.modulo    rotation angle modulo (positive real number)
rfl.mode      reflection mode [0,1]
rfl.lock      reflection lock [0,1]
rfl.bias      reflection bias (real number between 0-1)
rfl.list      reflection list (table of integers between 0-4)
scl.mode      scale mode [0,1,2]
scl.lock      scale lock [0,1]
scl.bias      scale bias (real number between 0-1)
scl.list      scale list (table of positive real numbers)
scl.range     scale range (2-element table of positive real numbers)
mov.mode      move mode [0,1,2]
mov.lock      move lock [0,1,2]
mov.bias      move bias (real number between 0-1)
mov.list      move list (table of positive real numbers)
mov.range     move range (2-element table of positive real numbers)
post_P        post scale mode [0,1,2]
post_O        post move value (real number)
xv            xform and variation definition table

The general structure of the rot (rotation), rfl (reflection), scl (scale)
and mov (move) include a mode setting, a lock setting, a bias value and a
list of discrete values for mode 1. The possible modes are:

mode 0 : transform disabled
mode 1 : randomize from list of discrete values
mode 2 : randomize from range of continuous values
mode 3 : (only for rotate) randomized rotation angles are modulo a given value

The reflection only has mode 0 and 1, since there are only 4 possible reflections.

Enabling the "lock" feature (by setting lock=1) tells the algorithm to only
randomize the given transform value once, and then use this value for all the
xforms in the current genome. The move transform has a special mode lock=2, that
spreads out the xforms equidistantly on a circle whose radius is now the randomized
parameter.

The post transforms are not randomized independently in this script, but two
modes of post transformation can be applied, calculated from the affine values.
The possible modes are:

post_P = 0 : no post transform (identity matrix)
post_P = 1 : sign reversal of the affine transform
post_P = 2 : matrix inverse of the affine transform
post_O : positive real number (0 = disabled)


Xform / Variation definition table: xv
--------------------------------------
The "xv" table defines the overall structure of the genome by specifying which
variations are to be used in which xforms. It is a table, containing one
sub-table for each xform, which in turn contains the variations for that xform.
Valid elements of the xv sub-tables are:

* variation numbers [currently between 1-61]
* 'r'
* groups
* keywords

The letter 'r' tells the algorithm to choose a variation randomly for that position,
drawn from the complete list of variations (1-61). Using the provided group 'all'
would do the same thing.

A "group" is a predefined named table of variation numbers. Inserting the name of a
group will cause the algorithm to select randomly a variation from those defined in
the group.

Keywords can be added to a given xform sub-table to override the global
transformation settings, and preventing specific parameters from being randomized.
Currently implemented keywords are:

rot     rotation angle (real number in degrees)
rfl     reflection mode (integer number between 0-4)
scl     scale value (positive real number)
mov     move value (2-element table {move_x,move_y} of real numbers)
xw      xform weight (real number)
col     xform color (positive real number)
sym     xform color (real number)
fx      final xform (set to 'Y' to enable)

The xform weight "xw" can take either a positive or a negative number. A positive
number sets the weight to that number, while a negative number tells the algorithm to
randomize the xform weight within the range specified by that number (e.g. setting
xw=-2 will randomize between -2 and +2).

The xform color is normally randomized; use the "col" keyword to set it to a fixed
value. The xform symmetry is by default zero, and not randomized, but can be set to
a given value by the "sym" keyword.

Lastly, the "final-xform" feature can be enabled by setting the keyword fx='Y'. For
backwards compatibility the old notation of using the minus sign on the variation number
still works, although this method can not be applied to a group.


EXAMPLES:
Here is a simple example: xv = {{1},{3},{14}}

A more complex example: xv = {{14,1},{55,scl=1},{-58,3},{57,mov={0,0}}}

And a ridiculously complex example, employing all the keywords:

noise = {27,28,29,45}
julia = {14,43,57,58,61}

xv = {{3,noise,xw=0.5,col=1,sym=0.2,rot=45,scl=1,rfl=1,mov={0.1,0}},
      {julia,col=0,sym=0.1,rot=90,scl=1,rfl=2,mov={0,0.1},fx='Y'},
      {1,14,xw=-1.5,col=0.6,sym=-0.2,rot=135,scl=1,rfl=3,mov={-0.1,0}},
      {43,xw=-2,col=0.5,sym=-0.2,rot=180,scl=1,rfl=4,mov={0,-0.1}}}
]]

--=========================================================================
-- Linear array generator (float)
function agen (n,x0,x1)
   array = {}
   dx = (x1-x0)/(n-1)
   for i=1,n do array[i] = x0+(i-1)*dx end
   return array
end
--=========================================================================
-- Biased binary randomizer
function rnb(x)
   num = math.random()
   if type(x)=='nil' then x=0.5 end
   if num<=x then res=1 else res=0 end
   return res
end
--=========================================================================
-- sign randomizer
function rnds ()
   num = math.random()-0.5
   if num == 0 then res=1 
   else res = math.abs(num)/num end
   return res
end
--=========================================================================
-- Random uniform distribution [-n,n]
function rndu (n) return (math.random()*2-1)*n end
--=========================================================================
-- Gaussian distribution
function rndn (mu,sigma) 
   x1,x2 = math.random(),math.random()
   norm = math.sqrt(-2*math.log(x1))*math.cos(math.pi*2*x2)
   return mu+sigma*norm
end
--=========================================================================
-- Genome cloner
function clone_genome (genome) 
   local clone = {}
   for k,v in pairs(genome) do 
      if type(v) == "table" then
	 clone[k] = clone_genome(v)
      elseif k ~= "n" then	
	 clone[k] = v
      end  
   end 
   return clone
end
--=========================================================================
-- Print table to stdout
function printt (table,old_indent) 
   local indent = old_indent .. "    "
   for k,v in pairs(table) do 
      if type(v) == "table" then
	 print(indent .. k) 
	 printt(v, indent)
      elseif k ~= "n" then	
	 print(indent .. k,v) 
      end  
   end 
end
--=========================================================================
-- Variation randomizer
-- Wiki: http://electricsheep.wikispaces.com/Variations
function vran (vn,vamp)

   w = rndu(vamp)
   pi = math.pi

   if vn==1 then tmp = {name='linear',weight=w} end
   if vn==2 then tmp = {name='sinusoidal',weight=w} end
   if vn==3 then tmp = {name='spherical',weight=w} end
   if vn==4 then tmp = {name='swirl',weight=w} end
   if vn==5 then tmp = {name='horseshoe',weight=w} end
   if vn==6 then tmp = {name='polar',weight=w} end
   if vn==7 then tmp = {name='handkerchief',weight=w} end
   if vn==8 then tmp = {name='heart',weight=w} end
   if vn==9 then tmp = {name='disc',weight=w} end
   if vn==10 then tmp = {name='spiral',weight=w} end
   if vn==11 then tmp = {name='hyperbolic',weight=w} end
   if vn==12 then tmp = {name='diamond',weight=w} end
   if vn==13 then tmp = {name='ex',weight=w} end
   if vn==14 then tmp = {name='julia',weight=w} end
   if vn==15 then tmp = {name='bent',weight=w} end
   if vn==16 then tmp = {name='waves',weight=w} end
   if vn==17 then tmp = {name='fisheye',weight=w} end
   if vn==18 then tmp = {name='popcorn',weight=w} end
   if vn==19 then tmp = {name='exponential',weight=w} end
   if vn==20 then tmp = {name='power',weight=w} end
   if vn==21 then tmp = {name='cosine',weight=w} end
   if vn==22 then tmp = {name='rings',weight=w} end
   if vn==23 then tmp = {name='fan',weight=w} end
   if vn==24 then tmp = {name='eyefish',weight=w} end
   if vn==25 then tmp = {name='bubble',weight=w} end
   if vn==26 then tmp = {name='cylinder',weight=w} end
   if vn==27 then tmp = {name='noise',weight=w} end
   if vn==28 then tmp = {name='blur',weight=w} end
   if vn==29 then tmp = {name='gaussian_blur',weight=w} end
   if vn==30 then tmp = {name='arch',weight=w} end
   if vn==31 then tmp = {name='tangent',weight=w} end
   if vn==32 then tmp = {name='square',weight=w} end
   if vn==33 then tmp = {name='rays',weight=w} end
   if vn==34 then tmp = {name='blade',weight=w} end
   if vn==35 then tmp = {name='secant2',weight=w} end
   if vn==36 then tmp = {name='twintrian',weight=w} end
   if vn==37 then tmp = {name='cross',weight=w} end

   if vn == 38 then tmp = {name='blob',weight=w,
			   blob_high=rndu(5), 
			   blob_low=rndu(3), 
			   blob_waves=rndu(5)} end

   if vn == 39 then tmp = {name='pdj',weight=w,
			   pdj_a=rndu(pi), 
			   pdj_b=rndu(pi), 
			   pdj_c=rndu(pi), 
			   pdj_d=rndu(pi)} end
   if vn == 40 then
      f1,f2 = rndu(1),rndu(1)
      tmp0 = {f1,-f1,f2,f2}
      tmp = {name='fan2',weight=w,fan2_x=f1, fan2_y=tmp0[math.random(4)]}
   end
   if vn == 41 then tmp = {name='rings2',weight=w,
			   rings2_val=rndn(4,3)} end
   if vn == 42 then tmp = {name='perspective',weight=w,
			   perspective_angle=rndn(0,0.3), 
			   perspective_dist=rndu(5)} end
   if vn == 43 then tmp = {name='julian',weight=w,
			   julian_power=math.random(8), 
			   julian_dist=rndu(2)} end
   if vn == 44 then tmp = {name='juliascope',weight=w,
			   juliascope_power=math.random(8), 
			   juliascope_dist=rndu(2)} end
   if vn == 45 then tmp = {name='radial_blur',weight=w,
			   radial_blur_angle=rndu(1)} end
   if vn == 46 then tmp = {name='pie',weight=w,
			   pie_slices=rndn(5,5), 
			   pie_rotation=rndu(1), 
			   pie_thickness=rndu(0.5)} end
   if vn == 47 then tmp = {name='ngon',weight=w,
			   ngon_power=rnds()*math.random(4), 
			   ngon_sides=math.random(3,10), 
			   ngon_corners=rndu(2), 
			   ngon_circle=rndu(2)} end
   if vn == 48 then 
      c1,c2 = rndu(1),rndu(1)
      tmp0 = {c1,-c1,c2,c2}
      tmp = {name='curl',weight=w,curl_c1=c1, curl_c2=tmp0[math.random(4)]}
   end
   if vn == 49 then tmp = {name='rectangles',weight=w,
			   rectangles_x=rndu(1),
			   rectangles_y=rndu(1)} end
   if vn == 50 then tmp = {name='disc2',weight=w,
			   disc2_rot=rndn(4,3), 
			   disc2_twist=rndu(4)} end
   if vn == 51 then tmp = {name='super_shape',weight=w,
			   super_shape_m=rndu(2),super_shape_n1=rndu(2), 
			   super_shape_n2=rndu(4), super_shape_n3=rndu(4), 
			   super_shape_holes=(1+rndu(1))*2, super_shape_rnd=rndu(2)} end
   if vn == 52 then tmp = {name='flower',weight=w,
			   flower_holes=rndu(0.5), 
			   flower_petals=math.random(10)} end
   if vn == 53 then tmp = {name='conic',weight=w,
			   conic_holes=rndu(1), 
			   conic_eccentricity=rndu(1)} end
   if vn == 54 then tmp = {name='parabola',weight=w,
			   parabola_height=rndu(1), 
			   parabola_width=rndu(1)} end

-- Split and move removed in flam3 2.7.16 / Oxidizer 0.5.5 

-- User variations with partially fixed parameters
   if vn == 55 then tmp = {name='julian',weight=w,julian_power=5, julian_dist=rndu(2)} end
   if vn == 56 then tmp = {name='julian',weight=w,julian_power=3, julian_dist=rndu(2)} end
   if vn == 57 then tmp = {name='julian',weight=1,julian_power=2, julian_dist=-1} end
   if vn == 58 then tmp = {name='julian',weight=1,julian_power=3, julian_dist=-1} end
   if vn == 59 then tmp = {name='julian',weight=w,julian_power=2, julian_dist=rndu(2)} end
   if vn == 60 then tmp = {name='juliascope',weight=1,juliascope_power=3, juliascope_dist=-1} end
   if vn == 61 then tmp = {name='julian',weight=1.25*rnds(),
			   julian_power=math.random(2,5), 
			   julian_dist=rndu(2)} end

   return tmp
end
--=========================================================================
-- Main script: simil3
-- seed = os.time()
nvar = 61
variationSet.switchToVariationSetWithName("Flam3 Legacy")

-- <============= START user parameters ===============>

-- Info
edit = {
   nick="Ralf",
   date=os.date(),
   comm="Made by Lua script (simil4) for Fractal Architect",
   url="http://homepage.mac.com/rflicker/",
   previous_edits=""
}

-- nbat = 50         -- number of genomes to randomize
nbat = 1         -- number of genomes to randomize
qual = 25          -- rendering quality
erad = 0           -- estimator radius: set to 0 to turn off smoothing
vamp = 2         -- amplitude range (+/-) for variation weight
gsym = {-4,6}       -- randomize symmetry in this range
bias = 0.5         -- symmetry bias
color = 'ran'     -- xform color mode ('ran' or 'lin')

-- mode 0 - off
-- mode 1 - randomize from list
-- mode 2 - randomize from range
-- mode 3 - special (only rotation)

-- Rotation
rot = { mode = 2,
	lock = 0,
	bias = 1,
	list = {0,30,45,60,90},         -- mode 1
	range = {-5,5},               -- mode 2
	modulo = 45                     -- mode 3
     }

-- Reflection
rfl = { mode = 1,
	lock = 0,
	bias = 1,
	list = {0,1,2,3,4}  -- mode 1
}

-- Scale
scl = { mode = 2,
	lock = 1,
	bias = 1,
--	list = {1/2,1/math.sqrt(3),1/math.sqrt(2),math.sqrt(3)/2,1},  -- mode 1
--	list = {1/math.sqrt(2),math.sqrt(3)/2},  -- mode 1
	list = {1/2},
	range = {0.5,1}                                          -- mode 2
     }

-- Move
mov = { mode = 2,
	lock = 2,
	bias = 1,
--	list = {1/4,1/math.sqrt(3)/2,1/math.sqrt(2)/2,math.sqrt(3)/4,
--		1/2,1/math.sqrt(3),1/math.sqrt(2),math.sqrt(3)/2,1},  -- mode 1
	list = {1/math.sqrt(2)},  -- mode 1
	range = {0,1}                                              -- mode 2
}

-- Post mode
post_P = 0          -- mode: only 0,1 or 2
post_O = 0          -- any value (0=no post-shift of origin)

-- Groups
all = agen(nvar,1,nvar)
noise = {27,28,29,45}
faves = {1,2,3,14,22,43,48,52,53,57,58,61}
julia = {14,43,57,58,61}
nojul = {1,2,3,22,48,52,53}
symxy = {11,12,13,14,27,28,29,43,44,45}
base  = {1,2,3,17,19,24,25}
sky = {3,8,24,33,29,45}
-- create your own groups here

-- Example Xform/Variations

xv = {{43,xw=-2},{-3,14},{42,xw=-2},{all}}
--xv = {{43,xw=-2,mov={0,0}},{1,xw=-2},{-3},{all}}
--xv = {{1,xw=-2},{-3},{43,xw=-2,mov={0,0}},{all}}
--xv = {{1,xw=-2,rot=1},{-3,scale=0.96},{43,xw=-2,mov={0,0},rot=0},{all}}
--xv = {{3,xw=0.5,col=1,sym=0.2,rot=45,scl=1,rfl=1,mov={0.1,0}},
--      {julia,col=0,sym=0.1,rot=90,scl=1,rfl=2,mov={0,0.1},fx='Y'},
--      {1,14,xw=-1.5,col=0.6,sym=-0.2,rot=135,scl=1,rfl=3,mov={-0.1,0}},
--      {43,xw=-2,col=0.5,sym=-0.2,rot=180,scl=1,rfl=4,mov={0,-0.1}}}
--xv = {{sky},{julia},{noise},{julia}}
--xv = {{-14,3},{3},{julia,xw=-2}}
--xv = {{3},{25,1},{29,xw=-0.5},{3}}
--xv = {{'r'},{noise},{julia,xw=-3},{symxy}}
--xv = {{symxy,shift=0},{43},{61,xw=-2},{symxy,shift=0},{43,xw=-3}}
--xv = {{61,symx},{43,symx},{43,symx}}
--xv = {{julia},{nojul},{julia},{nojul}}
--xv = {{noise,xv=-0.75},{julia,xw=-3},{faves},{julia}}
--xv = {{nojul},{61,14},{61}}
--xv = {{faves,xw=2,sym=0.25},{61,fx='Y',sym=0.5},{61,faves,xw=5,sym=-0.5},{noise,sym=-0.5}}
--xv = {{noise},{faves},{faves},{faves}}
--xv = {{noise},{faves},{61,xw=1},{61}}
--xv = {{noise},{faves,fx='Y'},{61,xw=3},{faves}}
--xv = {{14},{55},{-58,3},{57}}
--xv = {{14},{56},{-3},{55}}
--xv = {{14},{56},{-57},{55},{1}}
--xv = {{14},{58},{59},{1}}
--xv = {{14},{-57},{43},{1}}
--xv = {{45},{-57,14},{43}}
--xv = {{27},{-57},{14},{43}}
--xv = {{1},{-57},{14},{43}}
--xv = {{27},{57},{2},{1}}
--xv = {{14,2},{-57},{43}}
--xv = {{52},{-21},{43}}
--xv = {{52,53},{-21,48},{43}}
--xv = {{52,53},{-21,48,2},{43,53}}
--xv = {{52,2,53},{-21,48,1},{43,53}}
--xv = {{52,2,53},{-21,48,14},{43,53}}
--xv = {{52,2,53},{-48,2,53,1},{43,53}}
--xv = {{52,2},{-21,48,14},{43}}
--xv = {{2},{14},{1},{43}}
--xv = {{1},{-43},{27},{43}}
--xv = {{14},{-43},{1}}
--xv = {{30},{43},{1},{43}}
--xv = {{30},{43},{1},{43},{14}}
--xv = {{43},{1},{43},{31}}
--xv = {{40},{43},{33},{43},{14}}
--xv = {{44},{43},{14}}
--xv = {{27},{43},{14}}
--xv = {{3},{'r'},{3},{'r'}}
--xv = {{43},{'r'},{14,},{1}}
--xv = {{40},{3,47},{1}}
--xv = {{49,3,1},{19,40,13}}
--xv = {{1},{27,41},{43}}
--xv = {{1},{48},{43}}
--xv = {{14},{43},{14}}
--xv = {{43},{-48},{43},{14}}
--xv = {{-48},{14},{43},{3}}
--xv = {{14},{-48},{43},{14}}
--xv = {{1},{-3,14},{48},{43}}
--xv = {{3,53},{-3},{1,48}}
--xv = {{1},{-57,48},{43}}


-- <============= END user parameters ===============>


-- Configuration name
nx = #xv
config = "E"..tostring(rot.mode)..tostring(rfl.mode)..tostring(scl.mode)..tostring(mov.mode)..".C"..tostring(rot.lock)..tostring(rfl.lock)..tostring(scl.lock)..tostring(mov.lock)..".P"..tostring(post_P).." ("..tostring(rot.modulo)..")"

-- Color map
--[[
ind = {  0,  30,  38,  67, 125, 149, 157, 194, 221, 245, 255}
r =   {251, 184, 184, 224,  75,  32,  76, 116, 225,  75, 165}
g =   {150,  58,  58,  94, 137,  72, 137, 111, 171, 137, 155}
b =   { 30,  19,  19,  24, 108, 212, 122, 253,  97, 108,  90}
new_cmap = {}
ncol = #ind
for j=1,ncol do new_cmap[j] = {index=ind[j], red=r[j], green=g[j], blue=b[j] } end
]]
new_cmap = makeRandomColors(math.random(8, 24))

-- Genome template
tmpgen = {
   time = 0,
   height = 300,
   width = 400,
   scale = 100,
   quality = qual,
   brightness = 4,
   estimator_radius = erad,
   estimator_curve = 0.75,
   estimator_minimum = 0,
   vibrancy = 1,
   gamma = 4,
   symmetry = '0',
   supersample = 2,
   filter_shape = "Gaussian",
   filter = 0.6,
   temporal_samples = 1,
   temporal_filter_type = 'Exponent',
   temporal_filter_exp = 0,
   interpolation = "linear",
   interpolation_type = "log"
}
tmpgen["edit"] = edit
tmpgen.colors = new_cmap


-- Loop over genomes
new_genomes  = {}
--math.randomseed(seed)
for i=1,nbat do
   print('Genome #'..tonumber(i))
   new_genome = clone_genome(tmpgen)

   -- Symmetry
   stmp = math.random(math.min(table.unpack(gsym)),math.max(table.unpack(gsym)))*rnb(bias)
   new_genome.symmetry = tostring(stmp)

   -- Locked: randomize only once per genome
   if rot.lock==1 and rot.mode>0 then 
      if rot.mode==1 then ang = rot.list[math.random(1,#rot.list)] end
      if rot.mode==2 then ang = math.random()*(rot.range[2]-rot.range[1])+rot.range[1] end
      if rot.mode==3 then ang = rot.modulo*math.random(0,math.floor(360/rot.modulo)) end
      ang = ang*rnb(rot.bias)
      ang = math.rad(ang)
   end
   if rfl.lock==1 then mode = rfl.list[math.random(1,#rfl.list)] end
   if scl.lock==1 then 
      if scl.mode==1 then scale = scl.list[math.random(1,#scl.list)] end
      if scl.mode==2 then scale = math.random()*(scl.range[2]-scl.range[1])+scl.range[1] end
      sbs = rnb(scl.bias)
   end
   if mov.lock>0 and mov.mode>0 then 
      if mov.mode==1 then rad = mov.list[math.random(1,#mov.list)] end
      if mov.mode==2 then rad = math.random()*(mov.range[2]-mov.range[1])+mov.range[1] end
      if mov.lock==3 then
	 if nx>1 then
	    txx,tyy = {},{}
	    dang = 360/(nx-1)*math.pi/180
	    txx[1],tyy[1] = 0,0
	    for x=1,nx-1 do
	       txx[x+1] = rad*math.cos(dang*(x-1))
	       tyy[x+1] = rad*math.sin(dang*(x-1))
	    end
	 else mov.lock=1 end
      end
      if mov.lock==1 then
	 tang = math.random()*2*math.pi
	 txx = rad*math.cos(tang)
	 tyy = rad*math.sin(tang)
      end
      if mov.lock==2 then
	 txx,tyy = {},{}
	 dang = 360/nx*math.pi/180
	 for x=1,nx do
	    txx[x] = rad*math.cos(dang*(x-1))
	    tyy[x] = rad*math.sin(dang*(x-1))
	 end
      end
      obs = rnb(mov.bias)
   end

   -- Loop over Xforms
   xforms,xn = {},{}
   for x=1,nx do
      print('  xform #'..tonumber(x))

      -- Rotation
      if rot.lock==0 and rot.mode>0 then 
	 if rot.mode==1 then ang = rot.list[math.random(1,#rot.list)] end
	 if rot.mode==2 then ang = math.random()*(rot.range[2]-rot.range[1])+rot.range[1] end
	 if rot.mode==3 then ang = rot.modulo*math.random(0,math.floor(360/rot.modulo)) end
	 ang = ang*rnb(rot.bias)
	 ang = math.rad(ang)
      end
      if rot.mode==0 then ang=0 end
      if  xv[x].rot~=nil then ang = math.rad(xv[x].rot) end
      Q1x = math.cos(ang)
      Q1y = math.sin(ang)
      Q2x = math.cos(ang+math.pi/2)
      Q2y = math.sin(ang+math.pi/2)
      print('    rot '..tonumber(math.deg(ang)))

      -- Reflection
      if rfl.lock==0 then mode = rfl.list[math.random(1,#rfl.list)] end
      if rfl.mode==0 then mode=0 end
      mode = mode*rnb(rfl.bias)
      if  xv[x].rfl~=nil then mode = xv[x].rfl end
      if mode==0 then M1x,M1y,M2x,M2y = Q1x,Q1y,Q2x,Q2y end       -- no transpose
      if mode==1 then M1x,M1y,M2x,M2y = Q1x,-Q1y,Q2x,-Q2y end     -- axis y=0
      if mode==2 then M1x,M1y,M2x,M2y = Q1y,Q1x,Q2y,Q2x end       -- axis y=x
      if mode==3 then M1x,M1y,M2x,M2y = -Q1x,Q1y,-Q2x,Q2y end     -- axis x=0
      if mode==4 then M1x,M1y,M2x,M2y = -Q1y,-Q1x,-Q2y,-Q2x end   -- axis y=-x
      print('    rfl '..tonumber(mode))

      -- Scale
      if scl.lock==0 then 
	 sbs = rnb(scl.bias)
	 if scl.mode==1 then scale = scl.list[math.random(1,#scl.list)] end	 
	 if scl.mode==2 then scale = math.random()*(scl.range[2]-scl.range[1])+scl.range[1] end
      end
      if scl.mode==0 then scale=1 else scale = scale*sbs+1-sbs end
      if xv[x].scl~=nil then scale = xv[x].scl end
      R1x = M1x*scale
      R1y = M1y*scale
      R2x = M2x*scale
      R2y = M2y*scale
      print('    scl '..tonumber(scale))

      -- Move
      if mov.mode~=0 then
	 if mov.lock==1 then tx,ty = txx,tyy end
	 if mov.lock==2 then tx,ty = txx[x],tyy[x] end
	 if mov.lock==3 then tx,ty = txx[x],tyy[x] end
	 if mov.lock==0 then
	    obs = rnb(mov.bias)
	    if mov.mode==2 then
	       tx = (math.random()*(mov.range[2]-mov.range[1])+mov.range[1])*rnds()*obs
	       ty = (math.random()*(mov.range[2]-mov.range[1])+mov.range[1])*rnds()*obs
	    end
	    if mov.mode==1 then
	       tx = mov.list[math.random(1,#mov.list)]*rnds()*obs
	       ty = mov.list[math.random(1,#mov.list)]*rnds()*obs
	    end
	 end
	 if xv[x].mov~=nil then tx,ty = xv[x].mov[1],xv[x].mov[2] end
      else tx,ty=0,0 end
      print('    mov '..tonumber(tx)..', '..tonumber(ty))
 
     
      -- Xform
      if xv[x].xw==nil then xw = math.abs(rndu(1))
      else 
	 if xv[x].xw<0 then xw = math.abs(xv[x].xw*rndu(1))
	 else xw = xv[x].xw end
      end
      if xv[x].col==nil then 
	 if color=='lin' then xcol = (x-1)/(nx-1) end
	 if color=='ran' then xcol = math.abs(rndu(1)) end
      else xcol = xv[x].col end
      if xv[x].sym==nil then xsym = 0
      else xsym = xv[x].sym end
      if xv[x].fx=='Y' then fx = 'Y'
      else fx = 'N' end 
      xform = {
	 is_finalxform=fx,
	 color    = xcol,
	 weight   = xw,
	 symmetry = xsym
      }
      coef = { {R1x , R1y}, {R2x , R2y}, {tx , ty} }
      xform.coefs = coef


      -- Post transform modes
      if post_P==0 then post = {{1 , 0},{0 , 1},{-tx*post_O , -ty*post_O}} end
      if post_P==1 then    -- Mode 1: "reverse"
	 post = { {-R1x/scale , -R1y/scale}, 
		  {-R2x/scale , -R2y/scale}, 
		  {-tx*post_O , -ty*post_O}}
      end
      if post_P==2 then    -- Mode 2: inverse
	 det = coef[1][1]*coef[2][2]-coef[1][2]*coef[2][1]
	 ds = det/math.abs(det)/scale
	 post = { {  R2y*ds , -R1y*ds}, 
		  { -R2x*ds ,  R1x*ds}, 
		  { -tx*post_O , -ty*post_O}}
      end
      xform.post = post


      -- Variations
      nv = #xv[x]
      variations,vn = {},{}
      for v=1,nv do
	 if xv[x][v]=='r' then vi = math.random(nvar) end
	 if type(xv[x][v])=='number' then vi = xv[x][v] end
	 if type(xv[x][v])=='table' then
	    nl = #xv[x][v]
	    vi = xv[x][v][math.random(nl)]
	 end
	 if vi<0 then          -- for backwards compatibility
	    vi = math.abs(vi)
	    xform.is_finalxform = 'Y'
	 end
	 vn[v] = vi
	 tmp = vran(vi,vamp)
	 variations[v] = tmp
	 print('    var '..tmp.name)
      end
      xform.variations = variations
      xforms[x] = xform
      new_genome["xforms"] = xforms
      table.insert(xn,vn)
   end

   
   -- Configuration name
   xpar = " "
   for i=1,nx do
      if xforms[i].is_finalxform=='Y' then xpar = xpar.."{" else xpar = xpar.."[" end
      xpar = xpar..table.concat(xn[i],".")
      if xforms[i].is_finalxform=='Y' then xpar = xpar.."}" else xpar = xpar.."]" end
   end
   name = config..xpar

   new_genome.name = name
   new_genome.time = i-1
   new_genomes[i] = new_genome
   
end

flame = new_genomes[1]
flame.varsetUuid = variationSet.uuid
oxidizer_genomes = new_genomes
--oxidizer_status["action"] = "replace"
