hud = {
    nextProgress = 0
}

function hud.drawEvents(chaosMod)
    for _, timer in ipairs(chaosMod.modules.Cron.timers) do
		for _, e in ipairs(chaosMod.runtimeData.activeEvents) do
            if e.cronID == timer.id then
                ImGui.ProgressBar(1 - ((e.settings.duration - timer.delay) / e.settings.duration), 100 * chaosMod.settings.hudSize, 15 * chaosMod.settings.hudSize, "")
                ImGui.SameLine()
                ImGui.Text(e.name)
            end
        end
	end
end

function hud.draw(chaosMod)
    local wWidth, wHeight = GetDisplayResolution()
    for _, timer in ipairs(chaosMod.modules.Cron.timers) do
		if timer.id == chaosMod.runtimeData.mainIntervalID then
                hud.nextProgress = (chaosMod.settings.interval - timer.delay) / chaosMod.settings.interval
			break
		end
	end

    chaosMod.CPS.setThemeBegin()
    chaosMod.CPS.styleBegin("WindowBorderSize", 0)
    chaosMod.CPS.colorBegin("WindowBg", {0,0,0,0})

    if (ImGui.Begin("hud", bit32.bor(ImGuiWindowFlags.AlwaysAutoResize, ImGuiWindowFlags.NoTitleBar))) then
        ImGui.SetWindowFontScale(chaosMod.settings.hudSize)
        if not chaosMod.settings.bigHUD then
            ImGui.ProgressBar(hud.nextProgress, 100 * chaosMod.settings.hudSize, 15 * chaosMod.settings.hudSize, "")
            ImGui.SameLine()  
            ImGui.Text("Next event")
            ImGui.Separator()
        end
        hud.drawEvents(chaosMod)
    end
    ImGui.End()


    if chaosMod.settings.bigHUD then
        if (ImGui.Begin("bigHUD", bit32.bor(ImGuiWindowFlags.AlwaysAutoResize, ImGuiWindowFlags.NoTitleBar))) then
            ImGui.SetWindowPos(0, -7)
            ImGui.ProgressBar(hud.nextProgress, wWidth, 12, "")
        end
    end
    ImGui.End()

    chaosMod.CPS.colorEnd(1)
    chaosMod.CPS.styleEnd(1)
    chaosMod.CPS.setThemeEnd()

end

return hud