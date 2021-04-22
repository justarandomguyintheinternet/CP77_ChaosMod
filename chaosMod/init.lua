local chaosMod = {
    ui = require("modules/ui/ui"),
    hud = require("modules/ui/hud"),
    fileSys = require("modules/fileSys"),
    utils = require("modules/utils"),

	runtimeData = { -- Stuff that shouldnt get saved
		showUI = false,
        CPSinstalled = false,
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
    events = {}
}

function chaosMod:new()

registerForEvent("onInit", function()
    pcall(function ()
		chaosMod.CPS = require("CPStyling")
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

    chaosMod.runtimeData.mainIntervalID = chaosMod.modules.Cron.Every(chaosMod.settings.interval, function()
        if chaosMod.utils.anyActiveEvent(chaosMod) then
            if chaosMod.settings.modActive then
                local currentRandomEvent = chaosMod.utils.getRandomEvent(chaosMod)

                --if chaosMod.settings.warningMessage then Game.GetPlayer():SetWarningMessage(tostring("Event \"" .. currentRandomEvent.name .. "\" in 5 seconds!"), 1) end    
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

registerForEvent("onUpdate", function(deltaTime)
    chaosMod.modules.Cron.Update(deltaTime)

    for _, e in ipairs(chaosMod.runtimeData.activeEvents) do
        e:run(deltaTime)
    end

    if chaosMod.runtimeData.inMenu or not chaosMod.settings.modActive then
        for _, timer in pairs(chaosMod.modules.Cron.timers) do
            chaosMod.modules.Cron.Pause(timer.id)
        end
    else
        for _, timer in pairs(chaosMod.modules.Cron.timers) do
            chaosMod.modules.Cron.Resume(timer.id)
        end
    end
end)

registerForEvent("onDraw", function()
    if chaosMod.runtimeData.showUI then
        chaosMod.ui.draw(chaosMod)
    end
    if chaosMod.settings.showHUD and chaosMod.runtimeData.isInGame and not chaosMod.runtimeData.inMenu and chaosMod.settings.modActive then
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

