ui = {
    filter = ""
}

function ui.drawBaseEventSettings(chaosMod)
    for _, v in pairs(chaosMod.events) do
        if (v.name:lower():match(ui.filter:lower())) ~= nil then
            v.settings.active, changed = ImGui.Checkbox(v.name, v.settings.active)
            if changed then chaosMod.fileSys.saveSettings(chaosMod) end
        end
    end
end

function ui.drawAdvancedSetttings(chaosMod)
    ui.filter = ImGui.InputTextWithHint('##Filter', 'Search for event...', ui.filter, 10)

    if ui.filter ~= '' then
        ImGui.SameLine()
        if ImGui.Button('X') then
            ui.filter = ''
        end
    end

    for _, event in pairs(chaosMod.events) do
        if (event.name:lower():match(ui.filter:lower()) ~= nil) then
            if ImGui.CollapsingHeader(event.name) then
                ImGui.PushID(tostring(event.name))
                event.settings.active, changed = ImGui.Checkbox("Active", event.settings.active)
                if changed then chaosMod.fileSys.saveSettings(chaosMod) end
                event.settings.duration, changed = ImGui.InputFloat("Duration", event.settings.duration, 0, 9999, "%.1f")
                event.settings.duration = math.min(math.max(event.settings.duration, 0), 9999)
                if changed then chaosMod.fileSys.saveSettings(chaosMod) end
                event.settings.chanceMultiplier, changed = ImGui.InputInt("Chance Multiplier", event.settings.chanceMultiplier, 0, 25000)
                event.settings.chanceMultiplier = math.min(math.max(event.settings.chanceMultiplier, 0), 25000)
                if changed then chaosMod.fileSys.saveSettings(chaosMod) end
                ImGui.Separator()
                pcall(function ()
                    event:drawCustomSettings()
                end)

                pressed = ImGui.Button("Reset Settings")
                if pressed then 
                    event.settings = chaosMod.utils.deepcopy(event.backupSettings)
                    chaosMod.fileSys.saveSettings(chaosMod)
                end

                ImGui.PopID()
            end
        end
    end
end

function ui.drawMainTab(chaosMod)
    ImGui.BeginChild("baseSettings", 375, 127, true)

        chaosMod.settings.modActive, changed = ImGui.Checkbox("Mod active", chaosMod.settings.modActive)
        if changed then
            if not chaosMod.settings.modActive then
                for _, e in pairs(chaosMod.runtimeData.activeEvents) do
                    e:deactivate()
                end
                for _, timer in pairs(chaosMod.modules.Cron.timers) do
                    if timer.id ~= chaosMod.runtimeData.mainIntervalID then
                        chaosMod.modules.Cron.Halt(timer.id)
                    else
                        chaosMod.modules.Cron.Pause(timer.id)
                        timer.delay = chaosMod.settings.interval
                    end
                end
            else
                chaosMod.modules.Cron.Resume(chaosMod.runtimeData.mainIntervalID)
            end
            chaosMod.runtimeData.activeEvents = {}
            chaosMod.fileSys.saveSettings(chaosMod)
        end

        ImGui.PushItemWidth(130)
        chaosMod.settings.interval, changed = ImGui.InputInt("Interval", chaosMod.settings.interval, 5, 6000)
        chaosMod.settings.interval = math.min(math.max(chaosMod.settings.interval, 5), 6000)
        if changed then 
            for _, timer in pairs(chaosMod.modules.Cron.timers) do
                if timer.id == chaosMod.runtimeData.mainIntervalID then
                    timer.timeout = chaosMod.settings.interval
                    timer.delay = chaosMod.settings.interval
                end
            end
            chaosMod.fileSys.saveSettings(chaosMod) 
        end

        ImGui.PopItemWidth()

        chaosMod.settings.showHUD, changed = ImGui.Checkbox("Show HUD", chaosMod.settings.showHUD)
        if changed then chaosMod.fileSys.saveSettings(chaosMod) end

        chaosMod.settings.bigHUD, changed = ImGui.Checkbox("Big HUD", chaosMod.settings.bigHUD)
        if changed then chaosMod.fileSys.saveSettings(chaosMod) end

        ImGui.PushItemWidth(130)
        chaosMod.settings.hudSize, changed = ImGui.InputFloat("HUD Size", chaosMod.settings.hudSize, 0.1, 5, "%.2f")
        if changed then chaosMod.fileSys.saveSettings(chaosMod) end
        chaosMod.settings.hudSize = math.min(math.max(chaosMod.settings.hudSize, 0.1), 10)
        ImGui.PopItemWidth()

    ImGui.EndChild()

    ImGui.Separator()
    ImGui.Text("Activate / Deactivate Events")

    ui.filter = ImGui.InputTextWithHint('##Filter', 'Search for event...', ui.filter, 10)

    if ui.filter ~= '' then
        ImGui.SameLine()
        if ImGui.Button('X') then
            ui.filter = ''
        end
    end

    if ImGui.Button("All on") then
        for _, e in pairs(chaosMod.events) do
            e.settings.active = true
        end
        chaosMod.fileSys.saveSettings(chaosMod)
    end
    ImGui.SameLine()
    if ImGui.Button("All off") then
        for _, e in pairs(chaosMod.events) do
            e.settings.active = false
        end
        chaosMod.fileSys.saveSettings(chaosMod)
    end

    ui.drawBaseEventSettings(chaosMod)
end

function ui.draw(chaosMod)
    chaosMod.CPS.setThemeBegin()

    if (ImGui.Begin("ChaosMod 0.1", ImGuiWindowFlags.AlwaysAutoResize)) then
        if ImGui.BeginTabBar("Tabbar", ImGuiTabBarFlags.NoTooltip) then
            chaosMod.CPS.styleBegin("TabRounding", 0)
            if ImGui.BeginTabItem("Main") then
                ui.drawMainTab(chaosMod)
                ImGui.EndTabItem()
            end
   
            if ImGui.BeginTabItem("Event Settings") then
                ui.drawAdvancedSetttings(chaosMod)
                ImGui.EndTabItem()
            end
            chaosMod.CPS.styleEnd(1)
            ImGui.EndTabBar()
        end
    end

    ImGui.End()
    chaosMod.CPS.setThemeEnd()
end

return ui