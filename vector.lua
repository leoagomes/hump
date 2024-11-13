--[[
Copyright (c) 2010-2013 Matthias Richter

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

local assert = assert
local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

---@class vector
---@field x number
---@field y number
---@operator add(vector): vector
---@operator add(number): vector
---@operator sub(vector): vector
---@operator sub(number): vector
---@operator mul(vector): vector
---@operator mul(number): vector
---@operator div(vector): vector
---@operator div(number): vector
---@operator unm: vector
---@operator len: number
-- eq, lt, le metamethods are currently unsupported by LuaLS
local vector = {}
vector.__index = vector

---Creates a new vector
---@param x number
---@param y number
---@return vector
local function new(x,y)
	return setmetatable({x = x or 0, y = y or 0}, vector)
end
local zero = new(0,0)

---Creates a new vector from polar coordinates
---@param angle number The angle in radians
---@param radius? number The radius (default 1)
---@return vector
local function fromPolar(angle, radius)
	radius = radius or 1
	return new(cos(angle) * radius, sin(angle) * radius)
end

---Creates a new vector with a random direction
---@param len_min number The minimum length
---@param len_max? number The maximum length (default len_min)
---@return vector
local function randomDirection(len_min, len_max)
	len_min = len_min or 1
	len_max = len_max or len_min

	assert(len_max > 0, "len_max must be greater than zero")
	assert(len_max >= len_min, "len_max must be greater than or equal to len_min")

	return fromPolar(math.random() * 2*math.pi,
	                 math.random() * (len_max-len_min) + len_min)
end

---Returns true if the given value is a vector
---@param v any
---@return boolean
local function isvector(v)
	return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

---Returns a copy of the vector
---@return vector
function vector:clone()
	return new(self.x, self.y)
end

---Unpacks the vector
---@return number, number # x, y
function vector:unpack()
	return self.x, self.y
end

function vector:__tostring()
	return "("..tonumber(self.x)..","..tonumber(self.y)..")"
end

function vector.__unm(a)
	return new(-a.x, -a.y)
end

function vector.__add(a,b)
	assert(isvector(a) and isvector(b), "Add: wrong argument types (<vector> expected)")
	return new(a.x+b.x, a.y+b.y)
end

function vector.__sub(a,b)
	assert(isvector(a) and isvector(b), "Sub: wrong argument types (<vector> expected)")
	return new(a.x-b.x, a.y-b.y)
end

function vector.__mul(a,b)
	if type(a) == "number" then
		return new(a*b.x, a*b.y)
	elseif type(b) == "number" then
		return new(b*a.x, b*a.y)
	else
		assert(isvector(a) and isvector(b), "Mul: wrong argument types (<vector> or <number> expected)")
		return a.x*b.x + a.y*b.y
	end
end

function vector.__div(a,b)
	assert(isvector(a) and type(b) == "number", "wrong argument types (expected <vector> / <number>)")
	return new(a.x / b, a.y / b)
end

function vector.__eq(a,b)
	return a.x == b.x and a.y == b.y
end

function vector.__lt(a,b)
	return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function vector.__le(a,b)
	return a.x <= b.x and a.y <= b.y
end

---Component-wise multiplication of two vectors
---@param a vector
---@param b vector
---@return vector
function vector.permul(a,b)
	assert(isvector(a) and isvector(b), "permul: wrong argument types (<vector> expected)")
	return new(a.x*b.x, a.y*b.y)
end

---Converts vector to polar coordinates
---@return vector # vector with x=angle, y=length
function vector:toPolar()
	return new(atan2(self.x, self.y), self:len())
end

---Returns the squared length of the vector
---@return number
function vector:len2()
	return self.x * self.x + self.y * self.y
end

---Returns the length of the vector
---@return number
function vector:len()
	return sqrt(self.x * self.x + self.y * self.y)
end

---Returns the distance between two points
---@param a vector
---@param b vector
---@return number
function vector.dist(a, b)
	assert(isvector(a) and isvector(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return sqrt(dx * dx + dy * dy)
end

---Returns the squared distance between two points
---@param a vector
---@param b vector
---@return number
function vector.dist2(a, b)
	assert(isvector(a) and isvector(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return (dx * dx + dy * dy)
end

---Normalizes the vector in-place
---@return vector self
function vector:normalizeInplace()
	local l = self:len()
	if l > 0 then
		self.x, self.y = self.x / l, self.y / l
	end
	return self
end

---Returns a normalized copy of the vector
---@return vector
function vector:normalized()
	return self:clone():normalizeInplace()
end

---Rotates the vector in-place
---@param phi number angle in radians
---@return vector self
function vector:rotateInplace(phi)
	local c, s = cos(phi), sin(phi)
	self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
	return self
end

---Returns a rotated copy of the vector
---@param phi number angle in radians
---@return vector
function vector:rotated(phi)
	local c, s = cos(phi), sin(phi)
	return new(c * self.x - s * self.y, s * self.x + c * self.y)
end

---Returns a perpendicular vector (rotated 90 degrees counter-clockwise)
---@return vector
function vector:perpendicular()
	return new(-self.y, self.x)
end

---Projects the vector onto another vector
---@param v vector vector to project onto
---@return vector
function vector:projectOn(v)
	assert(isvector(v), "invalid argument: cannot project vector on " .. type(v))
	-- (self * v) * v / v:len2()
	local s = (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x, s * v.y)
end

---Mirrors the vector on another vector
---@param v vector vector to mirror on
---@return vector
function vector:mirrorOn(v)
	assert(isvector(v), "invalid argument: cannot mirror vector on " .. type(v))
	-- 2 * self:projectOn(v) - self
	local s = 2 * (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x - self.x, s * v.y - self.y)
end

---Returns the cross product of two vectors
---@param v vector
---@return number
function vector:cross(v)
	assert(isvector(v), "cross: wrong argument types (<vector> expected)")
	return self.x * v.y - self.y * v.x
end

---Trims the vector to a maximum length in-place
---@param maxLen number maximum length
---@return vector self
function vector:trimInplace(maxLen)
	local s = maxLen * maxLen / self:len2()
	s = (s > 1 and 1) or math.sqrt(s)
	self.x, self.y = self.x * s, self.y * s
	return self
end

---Returns the angle between this vector and another vector (or x-axis if no vector provided)
---@param other? vector
---@return number angle in radians
function vector:angleTo(other)
	if other then
		return atan2(self.y, self.x) - atan2(other.y, other.x)
	end
	return atan2(self.y, self.x)
end

---Returns a copy of the vector trimmed to a maximum length
---@param maxLen number maximum length
---@return vector
function vector:trimmed(maxLen)
	return self:clone():trimInplace(maxLen)
end


-- the module
return setmetatable({
	new             = new,
	fromPolar       = fromPolar,
	randomDirection = randomDirection,
	isvector        = isvector,
	zero            = zero
}, {
	__call = function(_, ...) return new(...) end
})
