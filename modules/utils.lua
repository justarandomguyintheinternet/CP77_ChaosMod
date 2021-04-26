miscUtils = {}


function miscUtils.deepcopy(origin)
	local orig_type = type(origin)
    local copy
    if orig_type == 'table' then
        copy = {}
        for origin_key, origin_value in next, origin, nil do
            copy[miscUtils.deepcopy(origin_key)] = miscUtils.deepcopy(origin_value)
        end
        setmetatable(copy, miscUtils.deepcopy(getmetatable(origin)))
    else
        copy = origin
    end
    return copy
end

function miscUtils.deepestCopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[miscUtils.deepestCopy(k, s)] = miscUtils.deepestCopy(v, s) end
    return res
  end

function miscUtils.indexValue(table, value)
    local index={}
    for k,v in pairs(table) do
        index[v]=k
    end
    return index[value]
end

function miscUtils.has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function miscUtils.hasEntID(tab, ID)
    for _, value in ipairs(tab) do
        if value.hash == ID.hash then
            return true
        end
    end

    return false
end

function miscUtils.getIndex(tab, val)
    local index = nil
    for i, v in ipairs(tab) do
		if v == val then
			index = i
		end
    end
    return index
end

function miscUtils.getLength(tab)
    local count = 0
    for _ in pairs(tab) do 
        count = count + 1 
    end
    return count
end

function miscUtils.removeItem(tab, val)
    table.remove(tab, miscUtils.getIndex(tab, val))
end

function miscUtils.getRandomEvent(cM)
    local keys = {}
    for k, v in pairs(cM.events) do
        if v.settings.active then
            if not miscUtils.has_value(cM.runtimeData.activeEvents, v) then
                for var=1,v.settings.chanceMultiplier do
                    table.insert(keys, k)
                end
            end
            if #cM.runtimeData.activeEvents == 0 then
                for var=1,v.settings.chanceMultiplier do
                    table.insert(keys, k)
                end
            end
        end
    end

    return cM.events[keys[math.random(1, #keys)]]
end

function miscUtils.anyAvailableEvent(cM)
    local any = false
    for _, v in pairs(cM.events) do
        if v.settings.active == true then
            local running = false
            for _, e in pairs(cM.runtimeData.activeEvents) do
                if (v.name == e.name) then
                    running = true
                end
            end
            if not running then
                any = true
            end
        end
    end
    return any
end

function miscUtils.getObjects(range, filter) -- Filter must be any of those: https://codeberg.org/adamsmasher/cyberpunk/src/branch/master/core/gameplay/targetingSearchFilter.swift
    local objects = {}

    local range = range or Game["SNameplateRangesData::GetDisplayRange;"]()

    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    local result = {}
    local searchQuery = Game["TSQ_ALL;"]()
    searchQuery.maxDistance = range
    if filter then
        searchQuery.searchFilter = filter
    end

    _, result = targetingSystem:GetTargetParts(player, searchQuery, result) 
    for _, v in ipairs(result) do
        if not miscUtils.has_value(objects, v:GetComponent(v):GetEntity()) then
            table.insert(objects, v:GetComponent(v):GetEntity())
        end
    end

    return objects
end

return miscUtils