local _, NS = ...
local Data = NS.Data
local Util = NS.Util
local Core = NS.Core

local loadTracker = CreateFrame('Frame')
loadTracker:RegisterEvent('ADDON_LOADED')
loadTracker:SetScript('OnEvent', function(_, _, addonName)
    if addonName == 'HarreksAdvancedQol' then
        local settings = CopyTable(Data.settings)
        for _, setting in ipairs(settings) do
            if setting.func and type(setting.func) == "string" then
                setting.func = Core[setting.func]
            end
            if setting.func and type(setting.func) == 'function' then
                if HAQDB[setting.key] ~= nil then
                    setting.func(HAQDB[setting.key])
                elseif setting.default ~= nil then
                    setting.func(setting.default)
                end
            end
        end

        local HAUS = HarreksAdvancedUiSuite or {}
        local parent = HAUS and HAUS.settingsCategory or nil
        local LAMB = NS.LibAdvancedMenuBuilder
        local category = LAMB.CreateOptionsPanel(settings, HAQDB, 'Advanced QoL ' .. NS.Version, 'vertical', parent)

        if HAUS then
            HAUS.RegisterComponent('HarreksAdvancedQol', NS.Version, category.ID)
        end

        SLASH_HARREKSADVANCEDQOL1 = "/haq"
        SlashCmdList.HARREKSADVANCEDQOL = function()
            if InCombatLockdown() then
                print('|cnNORMAL_FONT_COLOR:AdvancedQoL:|r Settings can\'t be opened in combat.')
            else
                Settings.OpenToCategory(category.ID)
            end
        end
    end
end)
