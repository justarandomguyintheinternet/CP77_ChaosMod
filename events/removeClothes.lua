event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Sir this is a wendys"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    if not Game.GetPlayer():IsNaked() then
        Game.UnequipItem('Face', 0)
        Game.UnequipItem('Feet', 0)
        Game.UnequipItem('Head', 0)
        Game.UnequipItem('Legs', 0)
        Game.UnequipItem('OuterChest', 0)
        Game.UnequipItem('Outfit', 0)
        Game.UnequipItem('InnerChest', 0)
    end
end

function event:run()

end

function event:deactivate()

end

function event:drawCustomSettings()

end

return event