local pi, atan2	= math.pi, math.atan2
local sqrt, floor, max, huge	= math.sqrt, math.floor, math.max, math.huge

function smooth( points, s )	-- CatMull Spline - control point format {#,#}
	if #points < 3 then	return points	end
	local s			= s or 30	-- ~ number of steps between points
	local spline	= {}
	local p0, p1, p2, p3, x, y, steps
	for i = 1, #points-1 do
		if i == 1 then						-- first point (unique)
			p0, p1, p2, p3 = points[i], points[i], points[i + 1], points[i + 2]
			steps = floor( max( distance( p1, p2, s ), 4 ) )	-- # points dependent on distance (sort of)
			elseif	i == #points-1 then		-- last point (unique)
				p0, p1, p2, p3 = points[#points - 2], points[#points - 1], points[#points], points[#points]
				steps = floor( max( distance( p1, p2, s ), 4 ) )
			else
			p0, p1, p2, p3 = points[i - 1], points[i], points[i + 1], points[i + 2]
			steps = floor( max( distance( p1, p2, s ), 4 ) )
			end
		for t = 0, 1, 1 / steps do
			x = 0.5 * ( ( 2 * p1[1] ) + ( p2[1] - p0[1] ) * t + ( 2 * p0[1] - 5 * p1[1] + 4 * p2[1] - p3[1] ) * t * t + ( 3 * p1[1] - p0[1] - 3 * p2[1] + p3[1] ) * t * t * t )
			y = 0.5 * ( ( 2 * p1[2] ) + ( p2[2] - p0[2] ) * t + ( 2 * p0[2] - 5 * p1[2] + 4 * p2[2] - p3[2] ) * t * t + ( 3 * p1[2] - p0[2] - 3 * p2[2] + p3[2] ) * t * t * t )
			--prevent duplicate entries
			if not(#spline > 0 and spline[#spline][1] == x and spline[#spline][2] == y) then
				spline[#spline+1] = { floor(x), floor(y)}
				end
			end
		end
	return spline
	end

function distance( p1, p2, s )	-- steps between two control points
		local s = s or 1
		return floor(sqrt((p2[1]-p1[1])^2+(p2[2]-p1[2])^2) / s)
		end

function closestPoint( pointTable, pt )		-- find closest point in table to point
	local minDist		= huge
	local closestPoint	= 1
	for i = 1, #pointTable do
		local ds = distance( pointTable[i], pt )
		if ds < minDist then
			minDist			= ds
			closestPoint	= i
			end
		end
	return closestPoint
	end

