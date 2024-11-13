--[[
Copyright (c) 2012-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

---Converts vector components to string representation
---@param x number
---@param y number
---@return string
local function str(x,y)
	return "("..tonumber(x)..","..tonumber(y)..")"
end

---Multiplies vector components by a scalar
---@param s number Scalar value
---@param x number
---@param y number
---@return number x
---@return number y
local function mul(s, x,y)
	return s*x, s*y
end

---Divides vector components by a scalar
---@param s number Scalar value
---@param x number
---@param y number
---@return number x
---@return number y
local function div(s, x,y)
	return x/s, y/s
end

---Adds two vectors component-wise
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number x
---@return number y
local function add(x1,y1, x2,y2)
	return x1+x2, y1+y2
end

---Subtracts two vectors component-wise
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number x
---@return number y
local function sub(x1,y1, x2,y2)
	return x1-x2, y1-y2
end

---Multiplies two vectors component-wise
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number x
---@return number y
local function permul(x1,y1, x2,y2)
	return x1*x2, y1*y2
end

---Calculates dot product of two vectors
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number dot
local function dot(x1,y1, x2,y2)
	return x1*x2 + y1*y2
end

---Calculates determinant of two vectors
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number det
local function det(x1,y1, x2,y2)
	return x1*y2 - y1*x2
end

---Checks if two vectors are equal
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return boolean
local function eq(x1,y1, x2,y2)
	return x1 == x2 and y1 == y2
end

---Checks if first vector is less than second vector
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return boolean
local function lt(x1,y1, x2,y2)
	return x1 < x2 or (x1 == x2 and y1 < y2)
end

---Checks if first vector is less than or equal to second vector
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return boolean
local function le(x1,y1, x2,y2)
	return x1 <= x2 and y1 <= y2
end

---Calculates squared length of vector
---@param x number
---@param y number
---@return number
local function len2(x,y)
	return x*x + y*y
end

---Calculates length of vector
---@param x number
---@param y number
---@return number
local function len(x,y)
	return sqrt(x*x + y*y)
end

---Creates vector from polar coordinates
---@param angle number Angle in radians
---@param radius? number Optional radius (default 1)
---@return number x
---@return number y
local function fromPolar(angle, radius)
	radius = radius or 1
	return cos(angle)*radius, sin(angle)*radius
end

---Creates random direction vector
---@param len_min? number Minimum length (default 1)
---@param len_max? number Maximum length (default len_min)
---@return number x
---@return number y
local function randomDirection(len_min, len_max)
	len_min = len_min or 1
	len_max = len_max or len_min

	assert(len_max > 0, "len_max must be greater than zero")
	assert(len_max >= len_min, "len_max must be greater than or equal to len_min")

	return fromPolar(math.random()*2*math.pi,
	                 math.random() * (len_max-len_min) + len_min)
end

---Converts vector to polar coordinates
---@param x number
---@param y number
---@return number angle Angle in radians
---@return number radius Vector length
local function toPolar(x, y)
	return atan2(y,x), len(x,y)
end

---Calculates squared distance between two points
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
local function dist2(x1,y1, x2,y2)
	return len2(x1-x2, y1-y2)
end

---Calculates distance between two points
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
local function dist(x1,y1, x2,y2)
	return len(x1-x2, y1-y2)
end

---Normalizes a vector to unit length
---@param x number
---@param y number
---@return number x
---@return number y
local function normalize(x,y)
	local l = len(x,y)
	if l > 0 then
		return x/l, y/l
	end
	return x,y
end

---Rotates a vector by an angle
---@param phi number Angle in radians
---@param x number
---@param y number
---@return number x
---@return number y
local function rotate(phi, x,y)
	local c, s = cos(phi), sin(phi)
	return c*x - s*y, s*x + c*y
end

---Returns the perpendicular vector
---@param x number
---@param y number
---@return number x
---@return number y
local function perpendicular(x,y)
	return -y, x
end

---Projects one vector onto another
---@param x number Vector to project
---@param y number
---@param u number Vector to project onto
---@param v number
---@return number x
---@return number y
local function project(x,y, u,v)
	local s = (x*u + y*v) / (u*u + v*v)
	return s*u, s*v
end

---Mirrors a vector across another vector
---@param x number Vector to mirror
---@param y number
---@param u number Vector to mirror across
---@param v number
---@return number x
---@return number y
local function mirror(x,y, u,v)
	local s = 2 * (x*u + y*v) / (u*u + v*v)
	return s*u - x, s*v - y
end

---Trims a vector to a maximum length
---@param maxLen number Maximum length
---@param x number
---@param y number
---@return number x
---@return number y
local function trim(maxLen, x, y)
	local s = maxLen * maxLen / len2(x, y)
	s = s > 1 and 1 or math.sqrt(s)
	return x * s, y * s
end

---Calculates angle between two vectors
---@param x number
---@param y number
---@param u? number Second vector x component
---@param v? number Second vector y component
---@return number angle Angle in radians
local function angleTo(x,y, u,v)
	if u and v then
		return atan2(y, x) - atan2(v, u)
	end
	return atan2(y, x)
end

-- the module
return {
	str = str,

	fromPolar       = fromPolar,
	toPolar         = toPolar,
	randomDirection = randomDirection,

	-- arithmetic
	mul    = mul,
	div    = div,
	idiv   = idiv,
	add    = add,
	sub    = sub,
	permul = permul,
	dot    = dot,
	det    = det,
	cross  = det,

	-- relation
	eq = eq,
	lt = lt,
	le = le,

	-- misc operations
	len2          = len2,
	len           = len,
	dist2         = dist2,
	dist          = dist,
	normalize     = normalize,
	rotate        = rotate,
	perpendicular = perpendicular,
	project       = project,
	mirror        = mirror,
	trim          = trim,
	angleTo       = angleTo,
}
