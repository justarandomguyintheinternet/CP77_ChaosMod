event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "One hit Cars"
    o.settings = {
        active = true,
        duration = 75,
        chanceMultiplier = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()

end

function event:run(deltaTime)
    if self.chaosMod.input.shoot then
        local weapon = Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), TweakDBID.new('AttachmentSlots.WeaponRight'))
        if weapon then
            if Game['gameweaponObject::IsRanged;ItemID'](weapon:GetItemID()) then
                local obj = Game.GetTargetingSystem():GetLookAtObject(Game.GetPlayer(), false, false)
                if obj:IsVehicle() then
                    if not obj:IsDestroyed() then
                        local vComp = obj:GetVehicleComponent()
                        local vPS = obj:GetVehiclePS()
                        vComp:DestroyVehicle()
                        vComp:LoadExplodedState()
                        vComp:ExplodeVehicle(Game.GetPlayer())
                        vPS:ForcePersistentStateChanged()
                    end
                end
            end
        end
    end
end

function event:deactivate()

end

function event:drawCustomSettings()

end

return event