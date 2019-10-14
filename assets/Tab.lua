function Initialize()
    desktopMeasure = SKIN:GetMeasure('SetCurrentDesktop')
    panelColor = SKIN:GetVariable('PanelColor')
    panelHoverColor = SKIN:GetVariable('PanelHoverColor')
    panelItemWidth = tonumber(SKIN:GetVariable('PanelItemWidth'))
    panelItemHeight = tonumber(SKIN:GetVariable('PanelItemHeight'))
    indicatorWidth = tonumber(SKIN:GetVariable('PanelIndicatorWidth'))
    iconOrder = SKIN:GetVariable('IconOrder')
    barSize = SKIN:GetVariable('WinTaskbarSize')
end

function SetResolution(w, h)
    _G.screenWidth = w
    _G.screenHeight = h
    -- Set panel size
    if iconOrder == 'T2B' or iconOrder == 'B2T' then
        SKIN:Bang('!SetOption', 'Panel', 'X', 0)
        SKIN:Bang('!SetOption', 'Panel', 'Y', barSize)
        SKIN:Bang('!SetOption', 'Panel', 'W', panelItemWidth)
        SKIN:Bang('!SetOption', 'Panel', 'H', h)
        SKIN:Bang('!SetOption', 'PanelIndicator', 'W', indicatorWidth)
        SKIN:Bang('!SetOption', 'PanelIndicator', 'H', panelItemHeight)
    elseif iconOrder == 'L2R' or iconOrder == 'R2L' then
        SKIN:Bang('!SetOption', 'Panel', 'X', barSize)
        SKIN:Bang('!SetOption', 'Panel', 'Y', 0)
        SKIN:Bang('!SetOption', 'Panel', 'W', w)
        SKIN:Bang('!SetOption', 'Panel', 'H', panelItemHeight)
        SKIN:Bang('!SetOption', 'PanelIndicator', 'W', panelItemWidth)
        SKIN:Bang('!SetOption', 'PanelIndicator', 'H', indicatorWidth)
    end
end

function DisplayWorkspaces()
    -- used for relative y-offset changing
    local x = 0
    local y = 0

    -- safe-access variables
    local workspaces = _G.workspaces or {}
    local currentDesktop = _G.currentDesktop or 1
    
    -- Setup the workspace count for calculations
    local workspaceCount = #workspaces

    -- Set initial positions
    if iconOrder == 'T2B' then
        x = 0
        y = barSize
    elseif iconOrder == 'B2T' then
        x = 0
        y = _G.screenHeight - barSize - (workspaceCount * panelItemHeight)
    elseif iconOrder == 'L2R' then
        x = barSize
    elseif iconOrder == 'R2L' then
        x = _G.screenWidth - barSize - (workspaceCount * panelItemWidth)
    end

    -- Draw all of the workspace icons
    for idx, v in ipairs(workspaces) do
        local meter = v[1]
        local imgPath = SKIN:MakePathAbsolute(v[2])

        SKIN:Bang('!SetOption', meter, 'ImageName', imgPath)
        SKIN:Bang('!SetOption', meter, 'PreserveAspectRatio', 1)
        SKIN:Bang('!SetOption', meter, 'Padding', '6,4,6,4')
        SKIN:Bang('!SetOption', meter, 'X', x)
        SKIN:Bang('!SetOption', meter, 'Y', y)
        SKIN:Bang('!SetOption', meter, 'W', panelItemWidth - 12)
        SKIN:Bang('!SetOption', meter, 'H', panelItemHeight - 8)

        local hover = '[!SetOption ' .. meter .. ' SolidColor ' .. panelHoverColor .. ']'
        local unhover = '[!SetOption ' .. meter .. ' SolidColor ' .. panelColor .. ']'
        local update = '[!UpdateMeter ' .. meter .. '][!Redraw]'

        if idx == currentDesktop then
            -- prevent active workspace from losing color
            SKIN:Bang('!SetOption', meter, 'SolidColor', panelHoverColor)
            SKIN:Bang('!SetOption', meter, 'MouseOverAction', '[]')
            SKIN:Bang('!SetOption', meter, 'MouseLeaveAction', '[]')

            -- Set the indicator meter
            local indicatorMeter = 'PanelIndicator'
            -- Move the indicator to the correct position
            if iconOrder == 'T2B' then
                SKIN:Bang('!SetOption', indicatorMeter, 'X', x + panelItemWidth - indicatorWidth)
                SKIN:Bang('!SetOption', indicatorMeter, 'Y', y)
            elseif iconOrder == 'B2T' then
                SKIN:Bang('!SetOption', indicatorMeter, 'X', x - panelItemWidth)
                SKIN:Bang('!SetOption', indicatorMeter, 'Y', y)
            elseif iconOrder == 'L2R' then
                SKIN:Bang('!SetOption', indicatorMeter, 'X', x)
                SKIN:Bang('!SetOption', indicatorMeter, 'Y', y + panelItemHeight - indicatorWidth)
            elseif iconOrder == 'R2L' then
                SKIN:Bang('!SetOption', indicatorMeter, 'X', x)
                SKIN:Bang('!SetOption', indicatorMeter, 'Y', y)
            end
            -- Redraw the indicator
            SKIN:Bang('!UpdateMeter', indicatorMeter)
        else
            -- Add hover color changing
            SKIN:Bang('!SetOption', meter, 'SolidColor', panelColor)
            SKIN:Bang('!SetOption', meter, 'MouseOverAction', hover .. update)
            SKIN:Bang('!SetOption', meter, 'MouseLeaveAction', unhover .. update)
            
            -- Add click handling
            local click = '[!SetVariable DesktopTarget (' .. idx .. ')][!UpdateMeasure SetDesktop][!CommandMeasure SetDesktop "Run"]'
            click = '[!CommandMeasure WorkspaceCreator "SetDesktop(' .. idx .. ')"]' .. click

            SKIN:Bang('!SetOption', meter, 'LeftMouseUpAction', click)
        end
        
        -- Redraw the icon
        SKIN:Bang('!UpdateMeter', meter)
        SKIN:Bang('!Redraw')

        if iconOrder == 'T2B' or iconOrder == 'B2T' then
            y = y + panelItemHeight
        elseif iconOrder == 'L2R' or iconOrder == 'R2L' then
            x = x + panelItemWidth
        end
    end
end

function SetDesktop(number)
    -- Set the global currentDesktop variable
    _G.currentDesktop = tonumber(number)
    -- Immediately display changes
    DisplayWorkspaces()
end

function SetCurrentDesktop()
    local desktop = desktopMeasure:GetStringValue()
    if desktop and desktop ~= '' then
        -- Cached the previous desktop to check if the two are different
        local prevDesktop = _G.currentDesktop
        -- Set the global currentDesktop variable
        _G.currentDesktop = tonumber(desktop)
        -- Update if needed (hasn't drawn, or needs to be drawn.)
        if prevDesktop == nil or _G.currentDesktop ~= prevDesktop then
            DisplayWorkspaces()
        end
    end
end

function SetDesktopData()
    -- Create the file streams
    local mainIniFile = SKIN:GetVariable('MainConfigFile')
    local configIni = SKIN:MakePathAbsolute(mainIniFile, 'r')
    local configFile = io.open(configIni, 'r')

    -- Create locally tracked variables
    local workspaces = {}
    local meterCount = 0

    -- Find the user-specified categories in the .ini config
	for line in configFile:lines() do
        if line ~= '' then
            line = trim(line)
            if starts_with(line, '[') and ends_with(line, ']') then
                local meter = line:sub(2, -2)
                if meter ~= 'Rainmeter' and meter ~= 'Metadata' and meter ~= 'Variables' then
                    table.insert(workspaces, { meter, 'assets/images/' .. meter .. '.png' })
                    meterCount = meterCount + 1
                end
            end
		end
    end
    
    -- Close the file stream
    configFile:close()

    -- Set the global workspaces variable
    _G.workspaces = workspaces

    -- Update the DesktopCount variable (used in CreateDesktops)
    SKIN:Bang('!SetVariable DesktopCount (' .. meterCount .. ')')
end

-- String functions below

function starts_with(str, start)
    return str:sub(1, #start) == start
 end
 
function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end