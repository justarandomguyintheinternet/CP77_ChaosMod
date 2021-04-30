event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Australian V"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10,
        invertSettings = true
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    if self.settings.invertSettings then
        self.chaosMod.modules.GameSettings.Set("/controls/fppcameramouse/FPP_MouseInvertX", true)
        self.chaosMod.modules.GameSettings.Set("/controls/fppcameramouse/FPP_MouseInvertY", true)
    end
end

function event:run()
    Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(180, 0, 0)))
end

function event:deactivate()
    Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(0, 0, 0)))
    if self.settings.invertSettings then
        self.chaosMod.modules.GameSettings.Set("/controls/fppcameramouse/FPP_MouseInvertX", false)
        self.chaosMod.modules.GameSettings.Set("/controls/fppcameramouse/FPP_MouseInvertY", false)
    end
end

function event:drawCustomSettings()
    self.settings.invertSettings, changed = ImGui.Checkbox("Invert mouse", self.settings.invertSettings)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event