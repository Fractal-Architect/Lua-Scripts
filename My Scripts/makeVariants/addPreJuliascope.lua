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

local PrePostVariations = require "PrePostVariationsModule"

-- 66.6667% chance of adding Julian varpar to Pre variation Group
PrePostVariations.preVarPar(
    { name="juliascope", weight=2.*math.random(),
      juliascope_power = math.random(1,3),
      juliascope_dist  = 0.1 + math.random() * 2.9},
    0.666667)
