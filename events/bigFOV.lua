event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "PC Player"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10,
        fov = 115
    }

    o.data = {
        oldFOV = 0
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    self.data.oldFOV = Game.GetPlayer():GetFPPCameraComponent():GetFOV()
end

function event:run()
    local cam = Game.GetPlayer():GetFPPCameraComponent()
    cam:SetFOV(self.settings.fov)
end

function event:deactivate()
    local cam = Game.GetPlayer():GetFPPCameraComponent()
    cam:SetFOV(self.data.oldFOV)
end

function event:drawCustomSettings()
    self.settings.fov, changed = ImGui.InputInt("FOV", self.settings.fov, 50, 200)
    self.settings.fov = math.min(math.max(self.settings.fov, 50), 200)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event