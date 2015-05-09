--[[

NAME: simil3.lua

TYPE: Lua script for Oxidizer http://oxidizer.sourceforge.net/

DESCRIPTION: Batch generation of random genomes by similarity transforms.

This script is the sequel of "randomiz3.lua" which generated random genomes
by randomizing the (P1,P2) vectors and the origin O independently. simil3
by contrast always preserves the shape of the triangle by applying only
a random selection of a finite set of similarity transforms: rotation,
transpose, scaling and shift of origin.

Although much of the parameter space is lost by constraining the
radomization only to similarity transforms, this method vastly improves
the chances of obtaining "nice" looking fractals with natural symmetry 
and sharp features.

PARAMETERS:
nbat               Number of genomes to randomize
amod               Rotation angles modulus (degrees)
enable_rotate      Enable triangle rotation [1/0]
enable_transp      Enable triangle transpose [1/0]
enable_scale       Enable triangle scaling [1/0]
enable_shift       Enable shift of origin [1/0]
constrain_rotate   All Xforms have same rotations [1/0]
constrain_transp   All Xforms have same transpose [1/0]
constrain_scale    All Xforms have same scaling [1/0]
constrain_shift    Xform shifts lie on a circle [1/0]
xv                 Variations to use in each Xform: 1-56
post_P             mode of "inverse" of the affine transformation of
                   (P1,P2) to apply in the post transformation [0/1/2]
post_O             level of the affine shift of origin (O) to apply with
                   opposite sign in the post transformation 

USAGE:
The Xform/Variations imput table xv has one row per Xform, and each row
has one element per variation. For instance: xv = {{1},{14},{3,44}} has
three Xforms, a single linear variation in the first Xform, a Julia
variation in the second, and both a spherical and a Juliascope in the 
third Xform.

If a 'r' is given instead of a number in xv, a variation will be selected
randomly for that position, e.g. xv = {{'r'},{14}}. The "Final Xform" can
also be enabled by entering a negative number, e.g. xv = {{-1},{14}} will
set the first Xform to be a final Xform.

COMMENTS:
There is ample room for tweaking also other parameters than the ones
listed above. The degree of success of this script hinges strongly on
properly "weighing the dice" by specifying appropriate shift and scale
vectors (t and s), and also in pre-specifying appropriate ranges of
of randomization for the multi-parameter variations.

The post transformations are not randomized in this script, as randomizing
twice the amount of parameters typically only reduces the probability of
getting lucky. The post transformations can be randomized with the
post-sim.lua script afterwards. Instead, this script offers the option to
apply the "inverse" of the affine transformation as a post transformation.

There are three modes of the (P1,P2) post transform: 0=no post (identity
matrix); 1="reverse sign"; 2=matrix inverse. Mode 1 is a reflection
about the origin with an optional shift. Since a similarity transform is
its own inverse, mode 2 means applying the affine transformation of
(P1,P2) also as post, with an optional revense shift given by post_O
(0=no shift; 1=full amount). 

DISCLAIMER:
This software is freeware. It comes without any warranty
and you may redistribute and modify it.

Written by Ralf Flicker August 2008 (www.twelfthnight.se)

]]

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- sign randomizer
local function rnds ()
   num = math.random()-0.5
   if num == 0 then res=1 
   else res = math.abs(num)/num end
   return res
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Uniform distribution [-1,1]
local function rndu () return math.random()*2-1 end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Gaussian distribution
local function rndn (mu,sigma)
   x1,x2 = math.random(),math.random()
   norm = math.sqrt(-2*math.log(x1))*math.cos(math.pi*2*x2)
   return mu+sigma*norm
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Genome cloner
local function clone_genome (genome)

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
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Print table to stdout
local function printt (table,old_indent)
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
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Multi-parameter variation randomizer
local function mpar (vn,vm,vamp)

   w = rndu()*vamp
   pi = math.pi
   if vn == 38 then tmp = {name=vm,weight=w,blob_high=rndu()*5, blob_low=rndu()*3, blob_waves=rndu()*5} end
   if vn == 39 then tmp = {name=vm,weight=w,pdj_a=rndu()*pi, pdj_b=rndu()*pi, pdj_c=rndu()*pi, pdj_d=rndu()*pi} end
   if vn == 40 then
      f1 = rndu()
      f2 =  rndu()
      tmp0 = {f1,-f1,f2,f2}
      tmp = {name=vm,weight=w,fan2_x=f1, fan2_y=tmp0[math.random(4)]}
   end
   if vn == 41 then tmp = {name=vm,weight=w,rings2_val=rndn(4,3)} end
   if vn == 42 then tmp = {name=vm,weight=w,perspective_angle=rndn(0,0.3), perspective_dist=rndu()*5} end
   if vn == 43 then tmp = {name=vm,weight=w,julian_power=math.random(8), julian_dist=rndu()*1.5} end
   if vn == 44 then tmp = {name=vm,weight=w,juliascope_power=math.random(6), juliascope_dist=rndu()*1.5} end
   if vn == 45 then tmp = {name=vm,weight=w,radial_blur_angle=rndu()} end
   if vn == 46 then tmp = {name=vm,weight=w,pie_slices=rndn(5,5), pie_rotation=rndu(), pie_thickness=rndu()/2} end
   if vn == 47 then tmp = {name=vm,weight=w,ngon_power=rnds()*math.random(4), ngon_sides=math.random(3,10), ngon_corners=rndu()*2, ngon_circle=rndu()*2} end
   if vn == 48 then 
      c1 = rndu()
      c2 =  rndu()
      tmp0 = {c1,-c1,c2,c2}
      tmp = {name=vm,weight=w,curl_c1=c1, curl_c2=tmp0[math.random(4)]}
   end
   if vn == 49 then tmp = {name=vm,weight=w,rectangles_x=rndu(),rectangles_y=rndu()} end
   if vn == 50 then tmp = {name=vm,weight=w,disc2_rot=rndn(4,3), disc2_twist=rndu()*4} end
   if vn == 51 then tmp = {name=vm,weight=w,super_shape_m=rndu()*2, super_shape_n1=rndu()*2, super_shape_n2=rndu()*4, super_shape_n3=rndu()*4, super_shape_holes=(1+rndu())*2, super_shape_rnd=rndu()*2} end
   if vn == 52 then tmp = {name=vm,weight=w,flower_holes=rndu()/2, flower_petals=math.random(10)} end
   if vn == 53 then tmp = {name=vm,weight=w,conic_holes=rndu(), conic_eccentricity=rndu()} end
   if vn == 54 then tmp = {name=vm,weight=w,parabola_height=rndu(), parabola_width=rndu()} end

-- Removed in flam3 2.7.16 / Oxidizer 0.5.5 
--   if vn == 55 then tmp = {name=vm,weight=w,split_xsize=rndu(), split_ysize=rndu()} end
--   if vn == 56 then tmp = {name=vm,weight=w,move_x=rndu(), move_y=rndu()} end

-- Here you can add variations with fixed parameters - also need to add the name to the list
   if vn == 55 then tmp = {name=vm,weight=w,julian_power=5, julian_dist=rndu()*2} end
   if vn == 56 then tmp = {name=vm,weight=w,julian_power=3, julian_dist=rndu()*2} end
   if vn == 57 then tmp = {name=vm,weight=1,julian_power=2, julian_dist=-1} end
   if vn == 58 then tmp = {name=vm,weight=1,julian_power=3, julian_dist=-1} end
   if vn == 59 then tmp = {name=vm,weight=w,julian_power=2, julian_dist=rndu()*2} end
   if vn == 60 then tmp = {name=vm,weight=1,juliascope_power=3, juliascope_dist=-1} end
   if vn == 61 then tmp = {name=vm,weight=1.25*rnds(),julian_power=math.random(2,5), julian_dist=rndu()*2} end

   return tmp
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Variation names
-- Wiki: http://electricsheep.wikispaces.com/Variations

function var_name (num)

   vname = {
      -- simple variations 37 (single-parameter)
      [1] = "linear", 
      [2] = "sinusoidal" , 
      [3] = "spherical" , 
      [4] = "swirl" , 
      [5] = "horseshoe" , 
      [6] = "polar" , 
      [7] = "handkerchief" , 
      [8] = "heart" ,  
      [9] = "disc" , 
      [10] = "spiral" , 
      [11] = "hyperbolic" , 
      [12] = "diamond" , 
      [13] = "ex" , 
      [14] = "julia" ,
      [15] = "bent" , 
      [16] = "waves" , 
      [17] = "fisheye" , 
      [18] = "popcorn" , 
      [19] = "exponential" , 
      [20] = "power" , 
      [21] = "cosine" , 
      [22] = "rings" , 
      [23] = "fan" ,
      [24] = "eyefish" , 
      [25] = "bubble" , 
      [26] = "cylinder" , 
      [27] = "noise" , 
      [28] = "blur" , 
      [29] = "gaussian_blur" , 
      [30] = "arch" , 
      [31] = "tangent" , 
      [32] = "square" , 
      [33] = "rays" , 
      [34] = "blade" , 
      [35] = "secant2" ,
      [36] = "twintrian" , 
      [37] = "cross",
      -- complex variations 19 (multi-parameter)
      [38] = "blob", --blob_high, blob_low, blob_waves
      [39] = "pdj", --pdj_a, pdj_b, pdj_c, pdj_d
      [40] = "fan2", --fan2_x, fan2_y
      [41] = "rings2", --rings2_val
      [42] = "perspective", --perspective_angle, perspective_dist
      [43] = "julian", --julian_power, julian_dist
      [44] = "juliascope", --juliascope_power, juliascope_dist
      [45] = "radial_blur",--radial_blur_angle
      [46] = "pie", --pie_slices, pie_rotation, pie_thickness
      [47] = "ngon",--ngon_power, ngon_sides, ngon_corners, ngon_circle
      [48] = "curl",--curl_c1, curl_c2
      [49] = "rectangles",--rectangles_x, rectangles_y
      [50] = "disc2", --disc2_rot, disc2_twist
      [51] = "super_shape", --supershape_m, supershape_n1, supershape_n2, 
                            --supershape_n3, supershape_holes, supershape_rnd
      [52] = "flower", --flower_holes, flower_petals
      [53] = "conic",  --conic_holes, conic_eccen
      [54] = "parabola",--parabola_height, parabola_width

-- Removed in flam3 2.7.16 / Oxidizer 0.5.5 
--      [55] = "split",--split_xsize, split_ysize
--      [56] = "move", --move_x, move_y

-- Additional variations with fixed parameters, as defined in the mpar function
      [55] = "julian", -- fixed
      [56] = "julian", -- fixed
      [57] = "julian", -- fixed
      [58] = "julian", -- fixed
      [59] = "julian", -- fixed
      [60] = "juliascope", -- fixed
      [61] = "julian" -- fixed
   }
   
   return vname[num]
   
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Main script: simil3
nvar = 61
variationSet.switchToVariationSetWithName("Flam3 Legacy")


-- <============= START user parameters ===============>

-- Info
edit = {
   nick="adonais",
   date=os.date(),
   comm="Made in Lua for Fractal Architect",
   url="http://www.twelfthnight.se/",
   previous_edits=""
}

nbat = 1         -- number of genomes to randomize
-- nbat = 100         -- number of genomes to randomize
qual = 20          -- rendering quality
erad = 0           -- estimator radius

-- Mappings [1=enabled, 0=disabled]
amod = 45              -- rotation angles in multiples of this angle (degrees)
enable_rotate = 1
enable_transp = 1
enable_scale = 1
enable_shift = 1

-- Constraints [1=enabled, 0=disabled]
constrain_rotate = 0
constrain_transp = 0
constrain_scale = 0
constrain_shift = 0

-- Apply "inverse" as post?
post_P = 0          -- mode: only 0,1 or 2
post_O = 0          -- any value (0=no post-shift of origin)

-- New stuff..
vamp = 1.0              -- amplitude range (+/-) of variation weight
noise = {27,28,29,45}
faves = {1,2,3,14,22,43,48,52,53,57,58,61}
julia = {14,43,57,58,61}
nojul = {1,2,3,22,48,52,53}
symxy = {11,12,13,14,27,28,29,43,44,45}
base  = {1,2,3,17,19,24,25}

-- Example Xform/Variations

xv = {{symxy},{43},{61,xw=-2},{symxy},{43,xw=-3}}
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
--xv = {{1},{-57,14},{43}}
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


-- Configuration of mappings (for genome name)
nx = #xv
config = "E"..tostring(enable_rotate)..tostring(enable_transp)..tostring(enable_scale)..tostring(enable_shift)..".C"..tostring(constrain_rotate)..tostring(constrain_transp)..tostring(constrain_scale)..tostring(constrain_shift)..".P"..tostring(post_P).." ("..tostring(amod)..")"

-- shift values (+/-)
t = {0,1/4,1/3,1/2,2/3,1/math.sqrt(2),math.sqrt(3)/2}

-- scale factors
s = {1/2,1/math.sqrt(3),1/math.sqrt(2),3/4,1,1,1,1}

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

-- Create genome template
new_genomes = {}
new_genome = {
   height = 300,
   width = 400,
--   scale = 20+enable_scale*10,
   scale = 100,
   quality = qual,
   brightness = 4,
   temporal_samples = 1,
   estimator_radius = erad,
   estimator_curve = 0.75,
   estimator_minimum = 0,
   vibrancy = 1,
   gamma = 4,
   symmetry = "No Symmetry",
   oversample = 2,
   filter_shape = "Gaussian",
   filter = 0.6,
   time = 0,
   interpolation = "linear",
   interpolation_type = "log"
}
new_genome["edit"] = edit
new_genome.colors = new_cmap
new_genomes = {}
new_genomes[1] = new_genome
oxidizer_genomes = new_genomes
--oxidizer_status["action"] = "replace"

-- rotation
nang = 360/amod
r = {}
for i=1,nang do r[i]=i-1 end
nr = #r

-- transpose/mirroring
m = {0,1,2,3,4}
nm = #m

td = {0,1}
nt = #t
nd = #td
ns = #s

-- Generate randomized mappings for the XForms and populate genome
genome = oxidizer_genomes[1]
new_genomes  = {}
-- math.randomseed(seed)
for i=1,nbat do
   new_genome = clone_genome(genome)

   -- for constrained parameters use same value for all xforms
   if constrain_rotate==1 then ang = r[math.random(nr)]*amod*math.pi/180 end
   if constrain_transp==1 then mode = m[math.random(nm)] end
   if constrain_scale==1 then scale = s[math.random(ns)] end
   if constrain_shift==1 then 
      rad = t[math.random(nt)]  --*td[math.random(nd)]
      dang = 360/nx*math.pi/180
      txx = {} tyy = {}
      for x=1,nx do
	 txx[x] = rad*math.cos(dang*(x-1))--*math.random(0,1)
	 tyy[x] = rad*math.sin(dang*(x-1))--*math.random(0,1)
      end
   end

   xforms = {}
   xn = {}
   for x=1,nx do

      -- rotation
      if constrain_rotate==0 then ang = amod*r[math.random(nr)]*math.pi/180 end
      if enable_rotate==0 then ang=0 end
      Q1x = math.cos(ang)
      Q1y = math.sin(ang)
      Q2x = math.cos(ang+math.pi/2)
      Q2y = math.sin(ang+math.pi/2)

      -- transpose
      if constrain_transp==0 then mode = m[math.random(nm)] end
      if enable_transp==0 then mode=0 end
      if mode==0 then        -- no transpose
	 M1x = Q1x
	 M1y = Q1y
	 M2x = Q2x
	 M2y = Q2y
      end
      if mode==1 then        -- axis y=0
	 M1x = Q1x
	 M1y = -Q1y
	 M2x = Q2x
	 M2y = -Q2y
      end
      if mode==2 then        -- axis y=x
	 M1x = Q1y
	 M1y = Q1x
	 M2x = Q2y
	 M2y = Q2x
      end
      if mode==3 then        -- axis x=0
	 M1x = -Q1x
	 M1y = Q1y
	 M2x = -Q2x
	 M2y = Q2y
      end
      if mode==4 then        -- axis y=-x
	 M1x = -Q1y
	 M1y = -Q1x
	 M2x = -Q2y
	 M2y = -Q2x
      end

      -- scaling
      if constrain_scale==0 then scale = s[math.random(ns)] end
      if enable_scale==0 then scale=1 end
      R1x = M1x*scale
      R1y = M1y*scale
      R2x = M2x*scale
      R2y = M2y*scale
      
      -- shift of origin
      if enable_shift==1 then
	 if constrain_shift==1 then 
	    tx = txx[x]
	    ty = tyy[x]
	 end
	 if constrain_shift==0 then 
	    tx = t[math.random(nt)]*rnds()*math.random(0,1)   -- *td[math.random(nd)]
	    ty = t[math.random(nt)]*rnds()*math.random(0,1)   -- *td[math.random(nd)]
	 end
      else tx=0 ty=0 end
      
      -- populate xform
      if type(xv[x].xw)=='nil' then xw = math.abs(rndu())
      else 
	 if xv[x].xw<0 then xw = math.abs(xv[x].xw*rndu())
	 else xw = xv[x].xw end
      end
      if type(xv[x].col)=='nil' then xcol = math.abs(rndu())  --(x-1)/(nx-1)
      else xcol = xv[x].col end
      if type(xv[x].sym)=='nil' then xsym = 0
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

      det = coef[1][1]*coef[2][2]-coef[1][2]*coef[2][1]
      ds = det/math.abs(det)/scale

      -- Mode 0: no post on (P1,P2)
      if post_P==0 then post = {{1 , 0},{0 , 1},{-tx*post_O , -ty*post_O}} end
      if post_P==1 then    -- Mode 1: "reverse"
	 post = { {-R1x/scale , -R1y/scale}, 
		  {-R2x/scale , -R2y/scale}, 
		  {-tx*post_O , -ty*post_O}}
      end
      if post_P==2 then    -- Mode 2: inverse
	 post = { {  R2y*ds , -R1y*ds}, 
		  { -R2x*ds ,  R1x*ds}, 
		  { -tx*post_O , -ty*post_O}}
      end
      xform.post = post

      nv = #xv[x]
      variations = {}
      vn = {}
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
	 vname = var_name(vi)
	 if vi>37 then tmp = mpar(vi,vname,vamp) 
	 else tmp = {name=vname,weight=rndu()*vamp} end
	 variations[v] = tmp
      end
      xform.variations = variations
      xforms[x] = xform
      new_genome["xforms"] = xforms
      table.insert(xn,vn)
   end
   
   -- Configuration of variations (for genome name)
   xpar = " "
   for i=1,nx do
      if xforms[i].is_finalxform=='Y' then xpar = xpar.."{" else xpar = xpar.."[" end
      xpar = xpar..table.concat(xn[i],".")
      if xforms[i].is_finalxform=='Y' then xpar = xpar.."}" else xpar = xpar.."]" end
   end
   name = config..xpar

   new_genome.name = name
   new_genome["time"] = i+genome["time"]
   new_genomes[i] = new_genome
   
end

flame = new_genomes[1]
flame.varsetUuid = variationSet.uuid
oxidizer_genomes = new_genomes
--oxidizer_status["action"] = "replace"	
