ui = {}

function ui.drawBaseEventSettings(chaosMod)
    for _, v in pairs(chaosMod.events) do
        v.settings.active, changed = ImGui.Checkbox(v.name, v.settings.active)
        if changed then chaosMod.fileSys.saveSettings(chaosMod) end
    end
end

function ui.drawAdvancedSetttings(chaosMod)
    for _, event in pairs(chaosMod.events) do
        if ImGui.CollapsingHeader(event.name) then
            ImGui.PushID(tostring(event.name))

            event.settings.active, changed = ImGui.Checkbox("Active", event.settings.active)
            if changed then chaosMod.fileSys.saveSettings(chaosMod) end
            event.settings.duration, changed = ImGui.InputFloat("Duration", event.settings.duration, 0, 9999, "%.1f")
            event.settings.duration = math.min(math.max(event.settings.duration, 0), 9999)
            if changed then chaosMod.fileSys.saveSettings(chaosMod) end
            event.settings.chanceMultiplier, changed = ImGui.InputInt("Chance Multiplier", event.settings.chanceMultiplier, 0, 9999)
            event.settings.chanceMultiplier = math.min(math.max(event.settings.chanceMultiplier, 0), 9999)
            if changed then chaosMod.fileSys.saveSettings(chaosMod) end
            ImGui.Separator()
            pcall(function ()
                event:drawCustomSettings()
            end)

            pressed = ImGui.Button("Reset Settings")
            if pressed then 
                event.settings = nil
                chaosMod.fileSys.saveSettings(chaosMod)
                chaosMod.fileSys.loadSettings(chaosMod)
            end

            ImGui.PopID()
        end
    end
end

function ui.drawMainTab(chaosMod)
    ImGui.BeginChild("baseSettings", 375, 85, true)

        chaosMod.settings.modActive, changed = ImGui.Checkbox("Mod active", chaosMod.settings.modActive)
        if changed then chaosMod.fileSys.saveSettings(chaosMod) end

        ImGui.PushItemWidth(130)
        chaosMod.settings.interval, changed = ImGui.InputInt("Interval (Hit \"Reload all mods\")", chaosMod.settings.interval, 20, 6000)
        if changed then chaosMod.fileSys.saveSettings(chaosMod) end
        --chaosMod.settings.interval = math.min(math.max(chaosMod.settings.interval, 20), 6000)
        ImGui.PopItemWidth()

        chaosMod.settings.warningMessage, changed = ImGui.Checkbox("Announce next event", chaosMod.settings.warningMessage)
        if changed then chaosMod.fileSys.saveSettings(chaosMod) end

    ImGui.EndChild()

    ImGui.Separator()
    ImGui.Text("Activate / Deactivate Events")

    ui.drawBaseEventSettings(chaosMod)
end

function ui.draw(chaosMod)
    if chaosMod.runtimeData.CPSinstalled then chaosMod.CPS:setThemeBegin() end

    if (ImGui.Begin("ChaosMod 0.1", ImGuiWindowFlags.AlwaysAutoResize)) then
        if ImGui.BeginTabBar("Tabbar", ImGuiTabBarFlags.NoTooltip) then
            if chaosMod.runtimeData.CPSinstalled then chaosMod.CPS.styleBegin("TabRounding", 0) end
            if ImGui.BeginTabItem("Main") then
                ui.drawMainTab(chaosMod)
                ImGui.EndTabItem()
            end
   
            if ImGui.BeginTabItem("Event Settings") then
                ui.drawAdvancedSetttings(chaosMod)
                ImGui.EndTabItem()
            end
            if chaosMod.runtimeData.CPSinstalled then chaosMod.CPS.styleEnd(1) end
            ImGui.EndTabBar()
        end
    end

    ImGui.End()
    if chaosMod.runtimeData.CPSinstalled then chaosMod.CPS:setThemeEnd() end
end

return ui