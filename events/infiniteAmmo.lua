event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Magical Ammo"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.ApplyEffectOnPlayer("GameplayRestriction.InfiniteAmmo")
end

function event:run(deltaTime)

end

function event:deactivate()
    local rmStatus = Game['StatusEffectHelper::RemoveStatusEffect;GameObjectTweakDBID'] 
    rmStatus(Game.GetPlayer(), "GameplayRestriction.InfiniteAmmo")
end

function event:drawCustomSettings()
    if ImGui.Button("Force deactivate") then
        self:deactivate()
    end
end

return event