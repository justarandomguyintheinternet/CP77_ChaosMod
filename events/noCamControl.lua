event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "No cam control"
    o.settings = {
        active = true,
        duration = 15,
        chanceMultiplier = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.ApplyEffectOnPlayer("GameplayRestriction.NoCameraControl")
end

function event:run(deltaTime)

end

function event:deactivate()
    local rmStatus = Game['StatusEffectHelper::RemoveStatusEffect;GameObjectTweakDBID'] 
    rmStatus(Game.GetPlayer(), "GameplayRestriction.NoCameraControl")
end

function event:drawCustomSettings()
    if ImGui.Button("Force deactivate") then
        self:deactivate()
    end
end

return event