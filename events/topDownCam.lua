event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "GTA 2"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10,
        height = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:toggleHead()
    local headItem = "Items.PlayerMaPhotomodeHead"
    if string.find(tostring(Game.GetPlayer():GetResolvedGenderName()), "Female") then
        headItem = "Items.PlayerWaPhotomodeHead"
    end

    local ts = Game.GetTransactionSystem()
    local gameItemID = GetSingleton('gameItemID')
    local tdbid = TweakDBID.new(headItem)
    local itemID = gameItemID:FromTDBID(tdbid)

        if ts:HasItem(Game.GetPlayer(), itemID) == false then
            Game.AddToInventory(headItem, 1)
        end

    Game.EquipItemOnPlayer(headItem, "TppHead")
end

function event:activate()
    local cam = Game.GetPlayer():GetFPPCameraComponent()
    cam:SetLocalPosition(Vector4.new(0, -self.settings.height, 0, 0))
    cam.pitchMax = -80
    self:toggleHead()
end

function event:run()
    Game.GetPlayer():GetFPPCameraComponent().pitchMax = -80
end

function event:deactivate()
    local cam = Game.GetPlayer():GetFPPCameraComponent()
    cam:SetLocalPosition(Vector4.new(0, 0, 0, 0))
    cam:ResetPitch()
    self:toggleHead()
end

function event:drawCustomSettings()
    self.settings.height, changed = ImGui.InputInt("Cam height", self.settings.height, 1, 100)
    self.settings.height = math.min(math.max(self.settings.height, 1), 100)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end

    if ImGui.Button("Force toggle head") then
        self:toggleHead()
    end
end

return event