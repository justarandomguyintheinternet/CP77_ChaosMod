local chaosMod = {
    ui = require("modules/ui/ui"),
    fileSys = require("modules/fileSys"),
    utils = require("modules/utils"),

	runtimeData = { -- Stuff that shouldnt get saved
		showUI = false,
        CPSinstalled = false,
        isInGame = false,
        inMenu = false,
        cronIDS = {every = nil,
                   activate = nil,
                   deactivate = nil},
        eventRunning = false,
        currentRandomEvent = nil
	},
    modules = {
        Cron = require("modules/external/Cron"),
        GameHUD = require("modules/external/GameHUD"),
        GameSession = require("modules/external/GameSession"),
        GameSettings = require("modules/external/GameSettings"),
        GameUI = require("modules/external/GameUI"),
    },
    defaultSettings = {
        modActive = true,
        interval = 30,
        warningMessage = true,
    },
    events = {}
}

function chaosMod:new()

registerForEvent("onInit", function()
    pcall(function ()
		chaosMod.CPS = GetMod("CPStyling"):New()
	end)
    if chaosMod.CPS ~= nil then chaosMod.runtimeData.CPSinstalled = true end

    chaosMod.fileSys.tryCreateConfig("config/config.json", chaosMod.defaultSettings)
    chaosMod.fileSys.loadSettings(chaosMod)

    Observe('RadialWheelController', 'OnIsInMenuChanged', function(isInMenu ) -- Setup observer and GameUI to detect inGame / inMenu
        chaosMod.runtimeData.inMenu = isInMenu 
    end)

    chaosMod.modules.GameUI.OnSessionStart(function()
        chaosMod.runtimeData.isInGame = true
    end)

    chaosMod.modules.GameUI.OnSessionEnd(function()
        chaosMod.runtimeData.isInGame = false
        chaosMod.runtimeData.eventRunning = false
        for _, id in pairs(chaosMod.runtimeData.cronIDS) do
            chaosMod.modules.Cron.Halt(id)
        end
    end)

    chaosMod.runtimeData.isInGame = not chaosMod.modules.GameUI.IsDetached() -- Required to check if ingame after reloading all mods

    chaosMod.runtimeData.cronIDS.every = chaosMod.modules.Cron.Every(chaosMod.settings.interval, function()
        if chaosMod.utils.anyActiveEvent(chaosMod) then
            chaosMod.runtimeData.currentRandomEvent = chaosMod.utils.getRandomEvent(chaosMod)

            if chaosMod.settings.modActive then
                if chaosMod.settings.warningMessage then Game.GetPlayer():SetWarningMessage(tostring("Event \"" .. chaosMod.runtimeData.currentRandomEvent.name .. "\" in 5 seconds!"), 1) end
                chaosMod.runtimeData.cronIDS.activate = chaosMod.modules.Cron.After(5, function()
                    chaosMod.runtimeData.eventRunning = true
                    chaosMod.runtimeData.currentRandomEvent:activate()
                end)

                local deactivationDelay = chaosMod.runtimeData.currentRandomEvent.settings.duration
                if deactivationDelay == 0 then deactivationDelay = chaosMod.settings.interval + 6 end -- 0 means full duration, -1 to make sure the event ends before the next one starts

                chaosMod.runtimeData.cronIDS.deactivate = chaosMod.modules.Cron.After(math.min(deactivationDelay, chaosMod.settings.interval - 1), function() -- +5.5 To make sure it always gets called after the event started
                    chaosMod.runtimeData.eventRunning = false
                    chaosMod.runtimeData.currentRandomEvent:deactivate()
                end)
            end
        end
    end)
end)

registerForEvent("onUpdate", function(deltaTime)
    chaosMod.modules.Cron.Update(deltaTime)

    if chaosMod.runtimeData.eventRunning then
        chaosMod.runtimeData.currentRandomEvent:run(deltaTime)
    end

    if chaosMod.runtimeData.inMenu then
        for _, id in pairs(chaosMod.runtimeData.cronIDS) do
            chaosMod.modules.Cron.Pause(id)
        end
    else
        for _, id in pairs(chaosMod.runtimeData.cronIDS) do
            chaosMod.modules.Cron.Resume(id)
        end
    end
end)

registerForEvent("onDraw", function()
    if chaosMod.runtimeData.showUI then
        chaosMod.ui.draw(chaosMod)
    end
end)

registerForEvent("onOverlayOpen", function()
    chaosMod.runtimeData.showUI = true
end)

registerForEvent("onOverlayClose", function()
    chaosMod.runtimeData.showUI = false
end)

end

return chaosMod:new()

