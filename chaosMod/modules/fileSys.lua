config = {}

function config.fileExists(filename)
    local f=io.open(filename,"r")
    if (f~=nil) then io.close(f) return true else return false end
end

function config.tryCreateConfig(path, data)
    local existed = true
	if not config.fileExists(path) then
        existed = false
        local file = io.open(path, "w")
        local jconfig = json.encode(data)
        file:write(jconfig)
        file:close()
    end
    return existed
end

function config.loadFile(path)    
    local file = io.open(path, "r")
    local config = json.decode(file:read("*a"))
    file:close()
    return config
end

function config.saveFile(path, data)
    local file = io.open(path, "w")
    local jconfig = json.encode(data)
    file:write(jconfig)
    file:close()
end

function config.saveSettings(cM)
    local saveData = cM.settings
    saveData.events = {}

    for _, event in pairs(cM.events) do
        saveData.events[event.name] = event.settings
    end

    local file = io.open("config/config.json", "w")
    local jconfig = json.encode(saveData)
    file:write(jconfig)
    file:close()
end

function config.loadSettings(cM)
    local events = {}
    local eventSettings = config.loadFile("config/config.json").events

    for _, file in pairs(dir("events")) do
        local m = require("events/" .. file.name):new(cM)
        
        events[m.name] = m

        if eventSettings ~= nil then
            if eventSettings[m.name] ~= nil then
                m.settings = eventSettings[m.name]
            end
        end
    end

    cM.settings = config.loadFile("config/config.json")
    cM.events = events

    config.saveSettings(cM)
end

return config