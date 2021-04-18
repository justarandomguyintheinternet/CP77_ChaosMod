event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM -- You can use CET-Kit modules, for example: self.chaosMod.modules.GameSettings. See https://github.com/psiberx/cp2077-cet-kit

    o.name = "The event name" -- Here goes the name of the effect that will be visible
    o.settings = { -- Everything in here gets saved to config file when calling self.chaosMod.fileSys.saveSettings(self.chaosMod), if you add a new value make sure to hit the "Reset Settings" button of the event
        active = true, -- This, duration and chanceMultiplier are always required
        chanceMultiplier = 10, -- This can be used to change how likely this event is to happen. DEFAULT FOR ALL EVENTS IS SUPPOSED TO BE 10
        duration = 7.5, -- This value sets how long the event is active / after what time the deactivate gets called. USE 0 TO MAKE IT RUN ALL THE TIME UNTIL THE NEXT EVENT
        var = 5 -- Custom variable that gets saved, code for its UI goes in event:drawCustomSettings()
    }

    o.data = {} -- Any data that doesnt need to get saved can go in here

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate() -- This gets called 5 seconds after the event got announced (Start of the event)
    print("This event started")
end

function event:run(deltaTime) -- This gets executed every frame for the duration of the event
    print("This event is running")
end

function event:deactivate() -- This gets called at the end of the events duration (End of the event)
    print("This event ended")
end

function event:drawCustomSettings() -- In here goes any UI code thats needed for custom settings (Will be drawn below the events settings in the "Event Settings" Tab).
    self.settings.var, changed = ImGui.SliderInt("Var", self.settings.var, 1, 100)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end -- Make sure to save any changes using self.chaosMod.fileSys.saveSettings(self.chaosMod)
end

return event

-- Looking at already existing events also helps understanding how to create new ones :D