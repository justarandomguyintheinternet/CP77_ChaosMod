observer = {}

function observer:new()
	local o = {} 

    o.name = "Name"
    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function observer:init()

end

return observer