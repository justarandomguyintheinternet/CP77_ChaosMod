event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Loooong loooong scopes"
    o.settings = {
        active = true,
        duration = 75,
        chanceMultiplier = 10,
        minAmount = 6,
        maxAmount = 12
    }

    o.data = {
        amount = 0,
        updateAmount = true
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    if self.chaosMod.modules.GameSettings.Get("/gameplay/difficulty/SwayEffect") ~= 1 then
        self.chaosMod.modules.GameSettings.Set("/gameplay/difficulty/SwayEffect", 1)
        self.chaosMod.modules.GameSettings.Save()
    end
end

function event:run(deltaTime)
    if self.chaosMod.input.adsComplete == true then
        if self.data.updateAmount then
            self.data.updateAmount = false
            self.data.amount = math.random(self.settings.minAmount, self.settings.maxAmount)
        end
    else
        self.data.updateAmount = true
    end
    Game.GetPlayer():GetFPPCameraComponent().zoomOverrideWeight = self.data.amount
end

function event:deactivate()

end

function event:drawCustomSettings()
    self.settings.minAmount, changed = ImGui.InputInt("Min Zoom", self.settings.minAmount, 1, 25)
    self.settings.minAmount = math.min(math.max(self.settings.minAmount, 1), 25)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end

    self.settings.maxAmount, changed = ImGui.InputInt("Max Zoom", self.settings.maxAmount, 1, 25)
    self.settings.maxAmount = math.min(math.max(self.settings.maxAmount, 1), 25)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event