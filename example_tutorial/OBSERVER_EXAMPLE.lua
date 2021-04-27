observer = {}

function observer:new()
	local o = {} 

    o.name = "inGameMenu" -- The name of the observer, will be used to access the observer (Inside event): self.chaosMod.observers.inGameMenu NO SPACES, SPECIAL CHARACTERS OR NUMBER AT START 
    o.data = {
        igMenu = nil -- Put your data in here, access inside event: self.chaosMod.observers.inGameMenu.data.igMenu
    }

	self.__index = self
   	return setmetatable(o, self)
end

function observer:init() -- Put your observers in here
    Observe('gameuiInGameMenuGameController', 'RegisterGlobalBlackboards', function(this) -- Cant use self here, use something else like this instead
        self.data.igMenu = this
    end)
end

return observer