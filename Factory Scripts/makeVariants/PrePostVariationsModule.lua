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

--[[ Randomly insert the group of variation and variation paramerters into the first Pre Variation Group of each transform
     varpars    table having:
                  name   - variation name
                  weight - variation weight
                  optional fully qualified variation parameters i.e. cpow_power = math.random(1, 5)
     weight     probability that the varpars are inserted - should be between 0. and 1.
]]
function M.preVarPar(varpars, weight)
    weight = weight or 0.3      -- if no weight parameter, set it to 30%
    for i,xform in ipairs(flame.xforms) do    
        if math.random() < weight then
            if xform.preVarGroups == nil then
    		      xform.preVarGroups = {}
            end	
            if #xform.preVarGroups == 0 then
                table.insert(xform.preVarGroups, {})
            end
        
            table.insert(xform.preVarGroups[1], varpars) -- add to first pre variation group
        end
    end
end

--[[ Randomly insert the group of variation and variation paramerters into the last Post Variation Group of each transform
     varpars    table having:
                  name   - variation name
                  weight - variation weight
                  optional fully qualified variation parameters i.e. cpow_power = math.random(1, 5)
     weight      probability that the varpars are inserted- should be between 0. and 1.
]]
function M.postVarPar(varpars, weight)
    weight = weight or 0.3      -- if no weight parameter, set it to 30%
    for i,xform in ipairs(flame.xforms) do    
        if math.random() < weight then
            if xform.postVarGroups == nil then
    		      xform.postVarGroups = {}
            end	
            if #xform.postVarGroups == 0 then
                table.insert(xform.postVarGroups, {})
            end
        
            table.insert(xform.postVarGroups[#xform.postVarGroups], varpars) -- add to last post variation group
        end
    end
end

-- some examples
function M.preCpow(weight)
    M.preVarPar({ name="cpow", weight=math.random(),
                    cpow_i     = 0.5 + math.random() * 1.5, 
                    cpow_power = math.random(1, 5),
                    cpow_r     = 0.1 + math.random() * 2.9},
                    weight)
end

function M.postCpow(weight)
    M.postVarPar({ name="cpow", weight=math.random(),
                    cpow_i     = 0.5 + math.random() * 1.5, 
                    cpow_power = math.random(1, 5),
                    cpow_r     = 0.1 + math.random() * 2.9},
                    weight)
end

function M.preCsch(weight)
    M.preVarPar({ name="csch", weight=math.random()},
                    weight)
end

function M.postCsch(weight)
    M.postVarPar({ name="csch", weight=math.random()},
                    weight)
end

return M