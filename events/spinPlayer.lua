event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Beyblade fuck yeah"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10,
        amount = 8
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    if math.random(0, 1) == 0 then 
        self.data.turnAmount = self.settings.amount
    else
        self.data.turnAmount = -self.settings.amount
    end
end

function event:run()
    Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Game.GetPlayer():GetWorldPosition(), EulerAngles.new(0,0,Game.GetPlayer():GetWorldYaw() + self.data.turnAmount))
end

function event:deactivate() 

end

function event:drawCustomSettings()
    self.settings.amount, changed = ImGui.InputInt("Turn Speed", self.settings.amount, 1, 25)
    self.settings.amount = math.min(math.max(self.settings.amount, 1), 25)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event
