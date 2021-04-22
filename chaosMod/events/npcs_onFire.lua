event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "This is fine"
    o.settings = {
        active = true,
        duration = 25,
        chanceMultiplier = 10
    }

    o.data = {
        timer = 0,
        timerDelay = 0.25
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()

end

function event:run(deltaTime)
    self.data.timer = self.data.timer + deltaTime
    if (self.data.timer > self.data.timerDelay) then
        self.data.timer = self.data.timer - self.data.timerDelay

        local objs = self.chaosMod.utils.getObjects(999, Game["TSF_NPC;"]())
        local applyStatusEffect = Game['StatusEffectHelper::ApplyStatusEffect;GameObjectTweakDBIDFloat'] 
        for _, v in pairs(objs) do
            applyStatusEffect(v, TweakDBID.new("BaseStatusEffect.Burning"), 0)
        end

    end
end

function event:deactivate() 

end

function event:drawCustomSettings()

end

return event