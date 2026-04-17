local _, NS = ...
local Data = NS.Data
local Util = NS.Util
local Core = NS.Core

function Core.ToggleScreenshotMessage(value)
    if not value then
        ActionStatus:UnregisterEvent("SCREENSHOT_SUCCEEDED")
    else
        ActionStatus:RegisterEvent("SCREENSHOT_SUCCEEDED")
    end
end

function Core.ToggleCombatLogging(value)
    if value and LoggingCombat() == false then
        LoggingCombat(value)
        print('HAQoL: Combat log started.')
    end
end

function Core.AutoSellAndRepair(value)
    if value then
        if not Core.MerchantWatch then
            Core.MerchantWatch = CreateFrame("Frame")
            Core.MerchantWatch:SetScript("OnEvent", function()
                C_MerchantFrame.SellAllJunkItems()
                RepairAllItems(false)
            end)
        end
        Core.MerchantWatch:RegisterEvent("MERCHANT_SHOW")
    else
        if Core.MerchantWatch then
            Core.MerchantWatch:UnregisterAllEvents()
        end
    end
end

function Core.MaxCameraDistance(value)
    C_CVar.SetCVar('cameraDistanceMaxZoomFactor', value)
end

function Core.ShowCoordinates(value)
    if value then
        if not Core.CoordinatesBlock then
            Core.CoordinatesBlock = CreateFrame("Frame", nil, UIParent)
            Core.CoordinatesBlock:SetSize(1, 1)
            Core.CoordinatesBlock:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -5, 5)
            Core.CoordinatesBlock.text = Core.CoordinatesBlock:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            Core.CoordinatesBlock.text:SetPoint("RIGHT", Core.CoordinatesBlock, "CENTER")
            Core.CoordinatesBlock.text:SetShadowColor(0, 0, 0, 1)
            Core.CoordinatesBlock.text:SetShadowOffset(-2, -2)
            Core.CoordinatesBlock.text:SetScale(1.2)
        end
        if not Core.CoordinatesBlock.ticker then
            Core.CoordinatesBlock.ticker = C_Timer.NewTicker(0.5, function()
                local map = C_Map.GetBestMapForUnit("player")
                if map then
                    local position = C_Map.GetPlayerMapPosition(map, "player")
                    if position then
                        local posX, posY = position:GetXY()
                        Core.CoordinatesBlock.text:SetText(math.floor(posX * 1000) / 10 .. ', ' .. math.floor(posY * 1000) / 10)
                    end
                end
            end)
        end
    else
        if Core.CoordinatesBlock and Core.CoordinatesBlock.ticker then
            Core.CoordinatesBlock.ticker:Cancel()
            Core.CoordinatesBlock.text:SetText('')
            Core.CoordinatesBlock.ticker = nil
        end
    end
end

function Core.WaypointCommand(value)
    if value then
        if not _G["SLASH_HAQWAY1"] then
            SLASH_HAQWAY1 = "/way"
            SlashCmdList.HAQWAY = function(params)
                if HAQDB['waypointCommand'] then
                    local coords = {}
                    for coord in string.gmatch(params, "([^ ]+)") do
                        table.insert(coords, coord)
                    end
                    local mapId = C_Map.GetBestMapForUnit("player")
                    if mapId and C_Map.CanSetUserWaypointOnMap(mapId) then
                        local location = UiMapPoint.CreateFromCoordinates(mapId, coords[1] / 100, coords[2] / 100)
                        C_Map.SetUserWaypoint(location)
                        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                    else
                        print('Waypoints unavailable right now.')
                    end
                end
            end
        end
    end
end

function Core.LowFoodReminder(value)
    if value then
        if not Core.FoodWatcher then
            Core.FoodWatcher = CreateFrame("Frame")
            Core.FoodWatcher.text = Core.FoodWatcher:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            Core.FoodWatcher.text:SetPoint("CENTER", UIParent, "CENTER", 0, 30)
            Core.FoodWatcher.text:SetScale(3)
            Core.FoodWatcher.text:SetText('BUY MORE FOOD')
            Core.FoodWatcher.text:Hide()
            Core.FoodWatcher:SetScript("OnEvent", function(_, event)
                if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
                    local mapId = C_Map.GetBestMapForUnit("player")
                    if mapId and mapId == 2393 then
                        local foodCount = C_Item.GetItemCount(HAQDB['chosenFood'])
                        if foodCount < 15 then
                            Core.FoodWatcher.text:Show()
                        end
                    else
                        Core.FoodWatcher.text:Hide()
                    end
                elseif event == "BAG_UPDATE" and Core.FoodWatcher.text:IsShown() then
                    local foodCount = C_Item.GetItemCount(HAQDB['chosenFood'])
                    if foodCount > 15 then
                        Core.FoodWatcher.text:Hide()
                    end
                end
            end)
        end
        Core.FoodWatcher:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        Core.FoodWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
        Core.FoodWatcher:RegisterEvent("BAG_UPDATE")
    else
        if Core.FoodWatcher then
            Core.FoodWatcher:UnregisterAllEvents()
            Core.FoodWatcher.text:Hide()
        end
    end
end

function Core.TogglePlayerCombatText(value)
    if value then
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator:Show()
    else
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator:Hide()
    end
end

function Core.ToggleTotemFrame(value)
    Data.shouldShowTotemFrame = value
    if not Data.totemFrameHooked then
        hooksecurefunc(TotemFrame, 'Show', function(self)
            if not Data.shouldShowTotemFrame then
                self:ClearAllPoints()
                self:Hide()
            end
        end)
        Data.totemFrameHooked = true
    end
end

function Core.ToggleEssenceFrame(value)
    Data.shouldShowEssenceFrame = value
    if not Data.essenceFrameHooked then
        hooksecurefunc(EssencePlayerFrame, 'Show', function(self)
            if not Data.shouldShowEssenceFrame then
                self:ClearAllPoints()
                self:Hide()
            end
        end)
        Data.essenceFrameHooked = true
    end
end

function Core.TargetInfoAnchors(value)
    if value then
        TargetFrameToT:ClearAllPoints()
        TargetFrameToT:SetPoint("BOTTOMLEFT", TargetFrame, "BOTTOMRIGHT", -40, 0);
        if not Data.targetCastbarHooked then
            hooksecurefunc(TargetFrameSpellBar, "AdjustPosition", function()
                if HAQDB['targetInfoAnchors'] then
                    Util.AdjustTargetCastbarPosition()
                end
            end)
            TargetFrameSpellBar:HookScript("OnShow", function()
                if HAQDB['targetInfoAnchors'] then
                    Util.AdjustTargetCastbarPosition()
                end
            end)
            Data.targetCastbarHooked = true
        end
    else
        local pt, p, rel, x, y = TargetFrameToT:GetPoint()
        TargetFrameToT:ClearAllPoints()
        TargetFrameToT:SetPoint("BOTTOMRIGHT", TargetFrame, "BOTTOMRIGHT", -35, -10)
    end
end

function Core.MoveCastBarTime(value)
    if value then
        PlayerCastingBarFrame.CastTimeText:ClearAllPoints()
        PlayerCastingBarFrame.CastTimeText:SetPoint("RIGHT", PlayerCastingBarFrame, "RIGHT", -4, 0)
    else
        PlayerCastingBarFrame.CastTimeText:ClearAllPoints()
        PlayerCastingBarFrame.CastTimeText:SetPoint("LEFT", PlayerCastingBarFrame, "RIGHT", 4, 0)
    end
end

function Core.AutoAcceptRoleQueue(value)
    if value then
        if not Core.RoleQueueTracker then
            Core.RoleQueueTracker = CreateFrame('Frame')
            Core.RoleQueueTracker:SetScript('OnEvent', function()
                LFDRoleCheckPopupAcceptButton:Click()
            end)
        end
        Core.RoleQueueTracker:RegisterEvent('LFG_ROLE_CHECK_SHOW')
    else
        if Core.RoleQueueTracker then
            Core.RoleQueueTracker:UnregisterAllEvents()
        end
    end
end

function Core.CastBarIcon(value)
    if not Core.CastBarIconFrame and value then
        Core.CastBarIconFrame = CreateFrame("Frame", nil, PlayerCastingBarFrame, "BackdropTemplate")
        Core.CastBarIconFrame:SetSize(25, 25)
        Core.CastBarIconFrame:SetPoint("RIGHT", PlayerCastingBarFrame, "LEFT", -2, -5.5)
        Core.CastBarIconFrame.texture = Core.CastBarIconFrame:CreateTexture(nil, "BACKGROUND")
        Core.CastBarIconFrame.texture:SetSize(25, 25)
    end
    if value then
        Core.CastBarIconFrame.texture:SetPoint("CENTER", Core.CastBarIconFrame, "CENTER")
        Core.CastBarIconFrame:RegisterEvent("UNIT_SPELLCAST_START")
        Core.CastBarIconFrame:SetScript("OnEvent", function(self, event, ...)
            local unit, _, spellId = ...
            if unit and not issecretvalue(unit) and unit == 'player' then
                local iconID = C_Spell.GetSpellTexture(spellId)
                Core.CastBarIconFrame.texture:SetTexture(iconID)
            end
        end)
    elseif Core.CastBarIconFrame then
        Core.CastBarIconFrame.texture:ClearAllPoints()
        Core.CastBarIconFrame:UnregisterAllEvents()
    end
end

function Core.CombatTimer(value)
    if value then
        if StopwatchFrame then
            StopwatchFrame:Show()
            StopwatchFrame:SetFrameStrata('LOW')
        end
        if not Core.CombatTimerTracker then
            Core.CombatTimerTracker = CreateFrame("Frame")
            Core.CombatTimerTracker:SetScript("OnEvent", function(self, event)
                if event == "PLAYER_REGEN_DISABLED" or event == "ENCOUNTER_START" then
                    if event == "ENCOUNTER_START" then
                        Core.CombatTimerTracker.encounter = true
                    else
                        Core.CombatTimerTracker.encounter = false
                    end
                    Stopwatch_Clear()
                    Stopwatch_Play()
                elseif event == "ENCOUNTER_END" or event == "PLAYER_REGEN_ENABLED" and not Core.CombatTimerTracker.encounter then
                    Stopwatch_Pause()
                    if event == "ENCOUNTER_END" then
                        local fightTime = StopwatchTickerMinute:GetText() .. ':' .. StopwatchTickerSecond:GetText()
                        local text = 'Encounter ended. Fight time: ' .. fightTime
                        print(text)
                    end
                end
            end)
        end
        Core.CombatTimerTracker:RegisterEvent("PLAYER_REGEN_DISABLED")
        Core.CombatTimerTracker:RegisterEvent("PLAYER_REGEN_ENABLED")
        Core.CombatTimerTracker:RegisterEvent("ENCOUNTER_START")
        Core.CombatTimerTracker:RegisterEvent("ENCOUNTER_END")
    else
        if StopwatchFrame then
            StopwatchFrame:SetFrameStrata('DIALOG')
            StopwatchFrame:Hide()
        end
        if Core.CombatTimerTracker then
            Core.CombatTimerTracker:UnregisterAllEvents()
        end
    end
end

function Core.CombatTimerScale(value)
    if StopwatchFrame then
        StopwatchFrame:SetScale(value)
    end
end

function Core.EnableCastTracker(value)
    if value then
        if not Core.CastTrackerFrame then
            Core.CastTrackerFrame = CreateFrame("Frame", nil, UIParent)
            local offsetX, offsetY, reference, relative
            if HAQDB['castTrackerCoords'] then
                offsetX = HAQDB['castTrackerCoords']['x']
                offsetY = HAQDB['castTrackerCoords']['y']
                reference = HAQDB['castTrackerCoords']['ref']
                relative = HAQDB['castTrackerCoords']['rel']
            else
                offsetX, offsetY = 0, 0
                reference, relative = "CENTER", "CENTER"
            end
            Core.CastTrackerFrame:SetPoint(reference, UIParent, relative,  offsetX, offsetY)
            Core.CastTrackerFrame:SetSize(HAQDB['castTrackerIconSize'] * 3, HAQDB['castTrackerIconSize'])
            Core.CastTrackerFrame.icons = {}
            for i = 1, 3 do
                Core.CastTrackerFrame.icons[i] = Core.CastTrackerFrame:CreateTexture(nil, "BACKGROUND")
                Core.CastTrackerFrame.icons[i]:SetSize(HAQDB['castTrackerIconSize'], HAQDB['castTrackerIconSize'])
                Core.CastTrackerFrame.icons[i]:SetTexture(577318)
            end
            Core.CastTrackerFrame.icons[1]:SetPoint("LEFT", Core.CastTrackerFrame, "LEFT")
            Core.CastTrackerFrame.icons[2]:SetPoint("CENTER", Core.CastTrackerFrame, "CENTER")
            Core.CastTrackerFrame.icons[3]:SetPoint("RIGHT", Core.CastTrackerFrame, "RIGHT")
            Core.CastTrackerFrame:SetScript("OnEvent", function(self, event, ...)
                local unit, _, spellId = ...
                if unit and not issecretvalue(unit) and unit == 'player' then
                    Core.CastTrackerFrame.icons[1]:SetTexture(Core.CastTrackerFrame.icons[2]:GetTexture())
                    Core.CastTrackerFrame.icons[2]:SetTexture(Core.CastTrackerFrame.icons[3]:GetTexture())
                    Core.CastTrackerFrame.icons[3]:SetTexture(C_Spell.GetSpellTexture(spellId))
                end
            end)
            Core.CastTrackerFrame:SetScript("OnMouseDown", function(self, button)
                if self:IsMovable() and button == 'LeftButton' then
                    self:StartMoving()
                end
            end)
            Core.CastTrackerFrame:SetScript("OnMouseUp", function(self, button)
                if button == 'LeftButton' then
                    self:StopMovingOrSizing()
                    local ref, _, rel, castFrameX, castFrameY = Core.CastTrackerFrame:GetPoint()
                    HAQDB['castTrackerCoords'] = {
                        ref = ref,
                        rel = rel,
                        x = castFrameX,
                        y = castFrameY
                    }
                end
            end)
            if not HAQDB['lockCastTracker'] then
                Core.CastTrackerFrame:SetMovable(true)
            end
        end
        Core.CastTrackerFrame:Show()
        Core.CastTrackerFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    else
        if Core.CastTrackerFrame then
            Core.CastTrackerFrame:UnregisterAllEvents()
            Core.CastTrackerFrame:Hide()
        end
    end
end

function Core.LockCastTracker(value)
    if not Core.CastTrackerFrame then
        Core.EnableCastTracker(HAQDB['castTracker'])
    else
        Core.CastTrackerFrame:SetMovable(not value)
    end
end

function Core.CastTrackerIconSize(value)
    if Core.CastTrackerFrame then
        Core.CastTrackerFrame:SetSize(value * 3, value)
        for i = 1, 3 do
            Core.CastTrackerFrame.icons[i]:SetSize(value, value)
        end
    end
end
