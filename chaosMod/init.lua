local chaosMod = {
    ui = require("modules/ui/ui"),
    hud = require("modules/ui/hud"),
    fileSys = require("modules/fileSys"),
    utils = require("modules/utils"),

	runtimeData = { -- Stuff that shouldnt get saved
		showUI = false,
        CPSinstalled = false,
        gtaTravelInstalled = false,
        traveling = false,
        isInGame = false,
        inMenu = false,
        mainIntervalID = nil,
        drawHUD = false,
        activeEvents = {}
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
        showHUD = true,
        bigHUD = false,
        hudSize = 1.0
    },
    sharedData = {
        timeDialation = 1
    },
    events = {}
}

function chaosMod:new()

registerForEvent("onInit", function()
    pcall(function ()
		chaosMod.CPS = require("CPStyling")
	end)
    if chaosMod.CPS ~= nil then chaosMod.runtimeData.CPSinstalled = true end

    pcall(function ()
		chaosMod.gtaTravel = GetMod("gtaTravel")
	end)
    if chaosMod.gtaTravel ~= nil then chaosMod.runtimeData.gtaTravelInstalled = true end

    chaosMod.fileSys.tryCreateConfig("config/config.json", chaosMod.defaultSettings)
    chaosMod.fileSys.loadSettings(chaosMod)

    Observe('RadialWheelController', 'OnIsInMenuChanged', function(isInMenu ) -- Setup observer and GameUI to detect inGame / inMenu
        chaosMod.runtimeData.inMenu = isInMenu 
    end)

    chaosMod.modules.GameUI.OnSessionStart(function()
        chaosMod.runtimeData.isInGame = true
        for _, timer in pairs(chaosMod.modules.Cron.timers) do
            chaosMod.modules.Cron.Resume(timer.id)
        end
    end)

    chaosMod.modules.GameUI.OnSessionEnd(function()
        chaosMod.runtimeData.isInGame = false
        chaosMod.runtimeData.eventRunning = false
        chaosMod.runtimeData.activeEvents = {}
        for _, timer in pairs(chaosMod.modules.Cron.timers) do
            if timer.id ~= chaosMod.runtimeData.mainIntervalID then
                chaosMod.modules.Cron.Halt(timer.id)
            else
                chaosMod.modules.Cron.Pause(timer.id)
                timer.delay = chaosMod.settings.interval
            end
        end
    end)

    chaosMod.runtimeData.isInGame = not chaosMod.modules.GameUI.IsDetached() -- Required to check if ingame after reloading all mods

    chaosMod.runtimeData.mainIntervalID = chaosMod.modules.Cron.Every(chaosMod.settings.interval, function()
        if chaosMod.utils.anyAvailableEvent(chaosMod) then
            if chaosMod.settings.modActive and chaosMod.runtimeData.isInGame then
                local currentRandomEvent = chaosMod.utils.getRandomEvent(chaosMod)

                table.insert(chaosMod.runtimeData.activeEvents, currentRandomEvent)
                currentRandomEvent:activate()

                local dID = chaosMod.modules.Cron.After(currentRandomEvent.settings.duration, function()
                    chaosMod.utils.removeItem(chaosMod.runtimeData.activeEvents, currentRandomEvent)
                    currentRandomEvent:deactivate()
                end)

                currentRandomEvent.cronID = dID

            end
        end
    end)
end)

registerForEvent("onShutdown", function ()
    for _, e in pairs(chaosMod.runtimeData.activeEvents) do
        e:deactivate()
    end
end)

registerForEvent("onUpdate", function(deltaTime)
    chaosMod.modules.Cron.Update(deltaTime)

    if chaosMod.runtimeData.gtaTravelInstalled then
        chaosMod.runtimeData.traveling = chaosMod.gtaTravel.flyPath
    end

    if chaosMod.runtimeData.inMenu or not chaosMod.settings.modActive or chaosMod.runtimeData.traveling then
        for _, timer in pairs(chaosMod.modules.Cron.timers) do
            chaosMod.modules.Cron.Pause(timer.id)
        end
    else
        for _, timer in pairs(chaosMod.modules.Cron.timers) do
            chaosMod.modules.Cron.Resume(timer.id)
        end
        for _, e in ipairs(chaosMod.runtimeData.activeEvents) do
            e:run(deltaTime)
        end
    end
end)

registerForEvent("onDraw", function()
    if chaosMod.runtimeData.showUI then
        chaosMod.ui.draw(chaosMod)
    end
    if chaosMod.settings.showHUD and chaosMod.runtimeData.isInGame and not chaosMod.runtimeData.inMenu and chaosMod.settings.modActive and not chaosMod.runtimeData.traveling then --lmao
        chaosMod.hud.draw(chaosMod)
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

