-- Cartesian to polar
function c2p (x,y)
   local r = math.sqrt(x^2+y^2)
   local a = math.atan2(y,x)
   return {r,a}
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Polar to Cartesian
function p2c (r,a)
   local x = r*math.cos(a)
   local y = r*math.sin(a)
   return {x,y}
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Pre Rotation of the affine (P1,P2) around O  -- traditional triangle rotation
function affine_Prot (xform,phs)
    for i=1,2 do
        local rphi = c2p(xform.coefs[i][1],xform.coefs[i][2])
        local xy = p2c(rphi[1],rphi[2]+math.rad(phs))
        xform.coefs[i][1] = xy[1]
        xform.coefs[i][2] = xy[2]
    end
end
-- Pre Rotation of the affine (P1,P2) around O  -- traditional triangle rotation - named here more like Apophysis
function affine_rotate (xform,phs)
    for i=1,2 do
        local rphi = c2p(xform.coefs[i][1],xform.coefs[i][2])
        local xy = p2c(rphi[1],rphi[2]+math.rad(phs))
        xform.coefs[i][1] = xy[1]
        xform.coefs[i][2] = xy[2]
    end
end
-- Pre Additive rotation of the affine O around (0,0) world center
function affine_Orot (xform,phs)
    if phs~=0 then
        rphi = c2p(xform.coefs[3][1],xform.coefs[3][2])
        xy = p2c(rphi[1],rphi[2]+math.rad(phs))
        xform.coefs[3][1] = xy[1]
        xform.coefs[3][2] = xy[2]
    end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Pre Translation
function affine_translate (xform,x,y)
	xform.coefs[3][1] = x
	xform.coefs[3][2] = y
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Pre Scale of the affine (P1,P2) by scale factor
function affine_scale (xform,sf)
	xform.coefs[1][1] = sf * xform.coefs[1][1]
	xform.coefs[1][2] = sf * xform.coefs[1][2]
	xform.coefs[2][1] = sf * xform.coefs[2][1]
	xform.coefs[2][2] = sf * xform.coefs[2][2]
	xform.coefs[3][1] = sf * xform.coefs[3][1]
	xform.coefs[3][2] = sf * xform.coefs[3][2]
end


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Post Rotation of the affine (P1,P2) around O  -- traditional triangle rotation
function postAffine_Prot (xform,phs)
    for i=1,2 do
        local rphi = c2p(xform.post[i][1],xform.post[i][2])
        local xy = p2c(rphi[1],rphi[2]+math.rad(phs))
        xform.post[i][1] = xy[1]
        xform.post[i][2] = xy[2]
    end
end
-- Post Rotation of the affine (P1,P2) around O  -- traditional triangle rotation - named here more like Apophysis
function postAffine_rotate (xform,phs)
    for i=1,2 do
        local rphi = c2p(xform.post[i][1],xform.post[i][2])
        local xy = p2c(rphi[1],rphi[2]+math.rad(phs))
        xform.post[i][1] = xy[1]
        xform.post[i][2] = xy[2]
    end
end
-- Post Additive rotation of the affine O around (0,0) world center
function postAffine_Orot (xform,phs)
    if phs~=0 then
        rphi = c2p(xform.post[3][1],xform.post[3][2])
        xy = p2c(rphi[1],rphi[2]+math.rad(phs))
        xform.post[3][1] = xy[1]
        xform.post[3][2] = xy[2]
    end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Post Translation
function postAffine_translate (xform,x,y)
    xform.post[3][1] = x
    xform.post[3][2] = y
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Post Scale of the affine (P1,P2) by scale factor
function postAffine_scale (xform,sf)
    xform.post[1][1] = sf * xform.post[1][1]
    xform.post[1][2] = sf * xform.post[1][2]
    xform.post[2][1] = sf * xform.post[2][1]
    xform.post[2][2] = sf * xform.post[2][2]
    xform.post[3][1] = sf * xform.post[3][1]
    xform.post[3][2] = sf * xform.post[3][2]
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- get a random variation name
function random_variation()
	return variationSet.variationlist[math.random(#variationSet.variationlist)]
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- get a uniform random number in range from low to high
function randInRange(low, high)
    return low + (high - low) * math.random()
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Randomize Pre Matrix
function randomPreMatrix (xform)
    local affineSelect =  math.random()

    -- 20% change of identity matrix
    if affineSelect > 0.2 and affineSelect <= 0.4 then
        affine_rotate(xform, randInRange(0., 2. * math.pi))
    end
    if affineSelect > 0.4 and affineSelect <= 0.6 then
        affine_translate(xform, randInRange(0., 1.5), randInRange(0., 1.5))
    end
    if affineSelect > 0.6 and affineSelect <= 0.8 then
        affine_scale(xform, randInRange(0.25, 1.5))
    elseif affineSelect > 0.8 then
        affine_rotate(xform,    randInRange(0., 2. * math.pi))
        affine_translate(xform, randInRange(0., 1.5), randInRange(0., 1.5))
        affine_scale(xform,     randInRange(0., 1.2))
    end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Randomize Post Matrix
function randomPostMatrix (xform)
    local affineSelect =  math.random()

    -- 60% change of identity matrix
    if affineSelect > 0.6 and affineSelect <= 0.7 then
        postAffine_rotate(xform, randInRange(0., 2. * math.pi))
    end
    if affineSelect > 0.7 and affineSelect <= 0.8 then
        postAffine_translate(xform, randInRange(0., 1.5), randInRange(0., 1.5))
    end
    if affineSelect > 0.8 and affineSelect <= 0.9 then
        postAffine_scale(xform, randInRange(0.25, 1.5))
    elseif affineSelect > 0.9 then
        postAffine_rotate(xform,    randInRange(0., 2. * math.pi))
        postAffine_translate(xform, randInRange(0., 1.5), randInRange(0., 1.5))
        postAffine_scale(xform,     randInRange(0., 1.2))
    end
end
