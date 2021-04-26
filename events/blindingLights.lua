event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Blinding Lights"
    o.settings = {
        active = true,
        duration = 75,
        chanceMultiplier = 10,
        strength = 5000,
        deactivate = true
    }

    o.data = {
        timer = 0,
        timerDelay = 0.25,
        ids = {}
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    self.data.ids = {}
end

function event:run(deltaTime)
    self.data.timer = self.data.timer + deltaTime
    if (self.data.timer > self.data.timerDelay) then
        self.data.timer = self.data.timer - self.data.timerDelay

        if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) ~= nil then
            local vController = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetController()
            vController:SetLightStrength(1, self.settings.strength, 0)
            vController:SetLightStrength(2, self.settings.strength, 0)
            vController:SetLightStrength(4, self.settings.strength, 0)
        end

        local objs = self.chaosMod.utils.getObjects(999)
        for _, v in pairs(objs) do
            if v:IsVehicle() then
                if not self.chaosMod.utils.hasEntID(self.data.ids, v:GetEntityID()) then
                    table.insert(self.data.ids, v:GetEntityID())
                end
                local vController = v:GetController()
                vController:SetLightStrength(1, self.settings.strength, 0)
                vController:SetLightStrength(2, self.settings.strength, 0)
                vController:SetLightStrength(4, self.settings.strength, 0)
            end
        end

    end
end

function event:deactivate()
    if self.settings.deactivate then
        if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) ~= nil then
            local vController = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetController()
            vController:SetLightStrength(1, 1, 0)
            vController:SetLightStrength(2, 1, 0)
            vController:SetLightStrength(4, 1, 0)
        end

        for _, v in pairs(self.data.ids) do
            local veh = Game.FindEntityByID(v)
            if veh then
                local vController = veh:GetController()
                vController:SetLightStrength(1, 1, 0)
                vController:SetLightStrength(2, 1, 0)
                vController:SetLightStrength(4, 1, 0)
            end
        end
    end
end

function event:drawCustomSettings()
    self.settings.strength, changed = ImGui.InputInt("Light strength", self.settings.strength, 100, 100000)
    self.settings.strength = math.min(math.max(self.settings.strength, 100), 100000)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end

    self.settings.deactivate, changed = ImGui.Checkbox("Deactivate lights after event", self.settings.deactivate)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event