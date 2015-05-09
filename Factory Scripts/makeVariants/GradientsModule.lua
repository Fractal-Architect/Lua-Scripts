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

local M = {}

local function rgb2hsv(rgb)
	local r, g, b = rgb.red, rgb.green, rgb.blue
	local mx = math.max(r, g, b)
	local mn = math.min(r, g, b)
	
	local h = 0
	if mx == mn then
		h = 0.
	elseif mx == r then
		h = .16666666667*(g-b)/(mx-mn)
	elseif mx == g then
		h = .16666666667*(b-r)/(mx-mn) + .33333333
	else
		h = .16666666667*(r-g)/(mx-mn) + .66666667
	end	
    h = h-math.floor(h);
	
	local s = 0.
	if mx == 0.0 then
		s= 0.0
	else
		s = (mx-mn)/(mx)
	end
	
    local v = mx;
	if v > 1. then
		v = 1.
	end
	return { hue = h, saturation = s, value = v }
end

local function hsv2rgb(hsv)
	local h, s, v  = hsv.hue, hsv.saturation, hsv.value
	local hi = math.floor(h*6.) % 6
	local f  =  h*6.0 - math.floor(h * 6.0)
	local p  =  v * (1. - s)
	local q  =  v * (1. - f*s)
	local t  =  v * (1. - (1. - f) * s)
	
	local r, g, b
	if hi == 0 then
        r = v
        g = t
        b = p
	elseif hi == 1 then
        r = q
        g = v
        b = p
	elseif hi == 2 then
        r = p
        g = v
        b = t
	elseif hi == 3 then
        r = p
        g = q
        b = v
	elseif hi == 4 then
        r = t
        g = p
        b = v	
	elseif hi == 5 then
        r = v
        g = p
        b = q
	end
	return { red = r, green = g, blue = b }
end

-- Make color gradient usimg Analagous color scheme
function M.analogousScheme(weightRandom)
    local nmin = 4 -- minimum number of colors
    local nmax = 50 -- maximum number of colors
    local ncol = math.random(nmin,nmax)

    -- cnode1RGB is the main reference color - here it is randomly selected
    local cnode1HSV = { hue=math.random(), saturation=0.6+0.4*math.random(), value==0.6+0.4*math.random() }

    local delta = 30./360.
    local hue1 = cnode1HSV.hue
    local hue2 = 0.
    local hue3 = 0.

    if hue1 - delta < 0. then
    	hue2 = hue1 - delta + 1.
    else
    	hue2 = hue1 - delta
    end
    if hue1 + delta > 1. then
    	hue2 = hue1 + delta - 1.
    else
    	hue2 = hue1 - delta
    end
    local cnode2HSV = { hue=hue2, cnode1HSV.saturation, cnode1HSV.value }
    local cnode3HSV = { hue=hue3, cnode1HSV.saturation, cnode1HSV.value }

    local new_cmap = {}
    local total = 0
    local lastLength = 0
    -- these weights are the same as the sliders in the Color Gradient editor
    local weight1, weight2,  weight3  = 1., 1., 1.
    local weightRandom = weightRandom or 0.2
    local sumWeights = weight1 + weight2 + weight3 + weightRandom
    local effWeight1 = weight1 / sumWeights
    local effWeight2 = weight2 / sumWeights
    local effWeight3 = weight3 / sumWeights

    for j=1,ncol do
    	local val   = math.random()
    	local hsv = {}
    	if val <= effWeight1 then
    		hsv = { hue=cnode1HSV.hue, saturation=math.random(), value=math.random() }
    	elseif val <= effWeight1 + effWeight2 then
    		hsv = { hue=cnode2HSV.hue, saturation=math.random(), value=math.random() }
    	elseif val <= effWeight1 + effWeight2 + effWeight3 then
    		hsv = { hue=cnode3HSV.hue, saturation=math.random(), value=math.random() }
    	else
    		hsv = { hue=math.random(), saturation=math.random(), value=math.random() }
    	end
    	local color = hsv2rgb(hsv)
        new_cmap[j] = {index=total, red=255.*color.red, green=255.*color.green, blue=255.*color.blue, 255. }

        lastLength = math.random()
        total      = total + lastLength
    end
    total = total - lastLength

    for j=1,ncol do
        new_cmap[j].index = math.round(new_cmap[j].index/total * 255)
    end
    new_cmap[1].index = 0.

    flame.colors = new_cmap
end

-- Make color gradient usimg Complementary color scheme
function M.complementaryScheme(weightRandom)
    local nmin = 4 -- minimum number of colors
    local nmax = 50 -- maximum number of colors
    local ncol = math.random(nmin,nmax)

    -- cnode1RGB is the main reference color - here it is randomly selected
    local cnode1HSV = { hue=math.random(), saturation=0.8+0.2*math.random(), value==0.6+0.4*math.random() }

    local delta = 180./360.
    local hue2 = 0.
    local hue1 = cnode1HSV.hue
    if hue1 - delta < 0. then
    	hue2 = hue1 - delta + 1.
    else
    	hue2 = hue1 - delta
    end
    local cnode2HSV = { hue=hue2, cnode1HSV.saturation, cnode1HSV.value }

    local new_cmap = {}
    local total = 0
    local lastLength = 0
    -- these weights are the same as the sliders in the Color Gradient editor
    local weight1, weight2  = 1., 1.
    local weightRandom = weightRandom or 0.2
    local sumWeights = weight1 + weight2 + weightRandom
    local effWeight1 = weight1 / sumWeights
    local effWeight2 = weight2 / sumWeights

    for j=1,ncol do
    	local val   = math.random()
    	local hsv = {}
    	if val <= effWeight1 then
    		hsv = { hue=cnode1HSV.hue, saturation=math.random(), value=math.random() }
    	elseif val <= effWeight1 + effWeight2 then
    		hsv = { hue=cnode2HSV.hue, saturation=math.random(), value=math.random() }
    	else
    		hsv = { hue=math.random(), saturation=math.random(), value=math.random() }
    	end
    	local color = hsv2rgb(hsv)
        new_cmap[j] = {index=total, red=255.*color.red, green=255.*color.green, blue=255.*color.blue, 255. }

        lastLength = math.random()
        total      = total + lastLength
    end
    total = total - lastLength

    for j=1,ncol do
        new_cmap[j].index = math.round(new_cmap[j].index/total * 255)
    end
    new_cmap[1].index = 0.

    flame.colors = new_cmap
end

-- Make color gradient usimg Grayscale color scheme
function M.grayscaleScheme(weightRandom)
    local nmin = 4 -- minimum number of colors
    local nmax = 50 -- maximum number of colors
    local ncol = math.random(nmin,nmax)

    -- cnode1RGB is the main reference color - here it is randomly selected
    local cnode1HSV = { hue=math.random(), saturation=0.8+0.2*math.random(), value==0.7+0.3*math.random() }

    local hue1 = cnode1HSV.hue

    local cnode2HSV = { hue=hue1, cnode1HSV.saturation, cnode1HSV.value }
    local cnode3HSV = { hue=hue1, cnode1HSV.saturation, cnode1HSV.value }

    local new_cmap = {}
    local total = 0
    local lastLength = 0
    -- these weights are the same as the sliders in the Color Gradient editor
    local weight1  = 1.
    local weightRandom = weightRandom or 0.2

    local sumWeights = weight1 + weightRandom
    local effWeight1 = weight1 / sumWeights

    for j=1,ncol do
    	local val   = math.random()
    	local hsv = {}
    	if val <= effWeight1 then
    		hsv = { hue=cnode1HSV.hue, saturation=0., value=math.random() }		
    	else
    		hsv = { hue=math.random(), saturation=math.random(), value=math.random() }
    	end
    	local color = hsv2rgb(hsv)
        new_cmap[j] = {index=total, red=255.*color.red, green=255.*color.green, blue=255.*color.blue, 255. }

        lastLength = math.random()
        total      = total + lastLength
    end
    total = total - lastLength

    for j=1,ncol do
        new_cmap[j].index = math.round(new_cmap[j].index/total * 255)
    end
    new_cmap[1].index = 0.

    flame.colors = new_cmap
end        

-- Make color gradient usimg Monochromatic color scheme
function M.monochromaticScheme(weightRandom)
    local nmin = 4 -- minimum number of colors
    local nmax = 50 -- maximum number of colors
    local ncol = math.random(nmin,nmax)

    -- cnode1RGB is the main reference color - here it is randomly selected
    local cnode1HSV = { hue=math.random(), saturation=0.8+0.2*math.random(), value==0.7+0.3*math.random() }

    local hue1 = cnode1HSV.hue

    local cnode2HSV = { hue=hue1, cnode1HSV.saturation, cnode1HSV.value }
    local cnode3HSV = { hue=hue1, cnode1HSV.saturation, cnode1HSV.value }

    local new_cmap = {}
    local total = 0
    local lastLength = 0
    -- these weights are the same as the sliders in the Color Gradient editor
    local weight1  = 1.
    local weightRandom = weightRandom or 0.2
    local sumWeights = weight1 + weightRandom
    local effWeight1 = weight1 / sumWeights

    for j=1,ncol do
    	local val   = math.random()
    	local hsv = {}
    	if val <= effWeight1 then
    		hsv = { hue=cnode1HSV.hue, saturation=math.random(), value=math.random() }		
    	else
    		hsv = { hue=math.random(), saturation=math.random(), value=math.random() }
    	end
    	local color = hsv2rgb(hsv)
        new_cmap[j] = {index=total, red=255.*color.red, green=255.*color.green, blue=255.*color.blue, 255. }

        lastLength = math.random()
        total      = total + lastLength
    end
    total = total - lastLength

    for j=1,ncol do
        new_cmap[j].index = math.round(new_cmap[j].index/total * 255)
    end
    new_cmap[1].index = 0.

    flame.colors = new_cmap
end

-- Make random color gradient
function M.randomColorsScheme()
    local nmin = 4 -- minimum number of colors
    local nmax = 50 -- maximum number of colors
    local ncol = math.random(nmin,nmax)

    local new_cmap = {}
    local total = 0
    local lastLength = 0

    for j=1,ncol do
        local r = math.random(256) - 1 --  returns random int in range 0 thru 255
        local g = math.random(256) - 1
        local b = math.random(256) - 1
        new_cmap[j] = {index=total, red=r, green=g, blue=b, alpha=255.}

        lastLength = math.random()
        total      = total + lastLength
    end
    total = total - lastLength

    for j=1,ncol do
        new_cmap[j].index = math.round(new_cmap[j].index/total * 255)
    end
    new_cmap[1].index = 0.

    flame.colors = new_cmap
end

-- Rotate color gradient
function M.rotateGradient()
    local ncol     = #flame.colors
    local new_cmap = {}
    local delta    = math.random(0, ncol-1) -- zero is no change - but we want that too as we want to see diffs side by side
    local j        = 1
    for i=1,delta do
        local color = flame.colors[ncol - delta + i]
        local index = flame.colors[j].index
        new_cmap[j] = {index=index, red=color.red, green=color.green, blue=color.blue, alpha=color.alpha }
        j           = j + 1
    end
    for i=1,ncol - delta do
        local color = flame.colors[i]
        local index = flame.colors[j].index
        new_cmap[j] = {index=index, red=color.red, green=color.green, blue=color.blue, alpha=color.alpha }
        j           = j + 1
    end

    flame.colors = new_cmap
end
    
return M

