observer = {}

function observer:new() 
	local o = {} 

    o.name = "inGameMenu"
    o.data = {
        igMenu = nil
    }

	self.__index = self
   	return setmetatable(o, self)
end


function observer:init()
    Observe('gameuiInGameMenuGameController', 'RegisterGlobalBlackboards', function(this)
        self.data.igMenu = this
    end)
end

return observer
