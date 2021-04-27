event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Black hole V"
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
    local objs = self.chaosMod.utils.getObjects(999)
    for _, v in pairs(objs) do
        Game.GetTeleportationFacility():Teleport(v, Game.GetPlayer():GetWorldPosition(), Quaternion.ToEulerAngles(Game.GetPlayer():GetWorldOrientation()))
    end
end

function event:run(deltaTime)

end

function event:deactivate()

end

function event:drawCustomSettings()

end

return event