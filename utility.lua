local _, NS = ...
local Data = NS.Data
local Util = NS.Util
local Core = NS.Core

function Util.GetTotemFramePoints()
    if not Data.totemFrame then
        local totemPoint, totemParent, totemRel, totemX, totemY = TotemFrame:GetPoint()
        Data.totemFrame = {
            point = totemPoint,
            parent = totemParent,
            relative = totemRel,
            xOffset = totemX,
            yOffset = totemY
        }
    end
    return Data.totemFrame
end

function Util.GetTargetOfTargetPoints()
    if not Data.targetOfTarget then
        local totPoint, totParent, totRel, totX, totY = TargetFrameToT:GetPoint()
        Data.targetOfTarget = {
            point = totPoint,
            parent = totParent,
            relative = totRel,
            xOffset = totX,
            yOffset = totY
        }
    end
    return Data.targetOfTarget
end

function Util.LoadTimeManager()
    local TimeManagerLoading = CreateFrame('Frame')
    TimeManagerLoading:RegisterEvent("PLAYER_LOGIN")
    TimeManagerLoading:SetScript("OnEvent", function()
        C_Timer.After(0.5, function()
            Core.CombatTimer(HAQDB.combatTimer)
            Core.CombatTimerScale(HAQDB.combatTimerScale)
        end)
    end)
end

function Util.AdjustTargetCastbarPosition()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPRIGHT", -5, -30)
end

-- Builds the 3 visible icons plus a 4th hidden one used to slide the next cast in from the right
function Util.CreateCastTrackerIcons(frame, iconSize)
    frame.icons = {}
    for i = 1, 4 do
        local icon = frame:CreateTexture(nil, "BACKGROUND")
        icon:SetTexture(577318)
        icon.slideGroup = icon:CreateAnimationGroup()
        icon.slideAnim = icon.slideGroup:CreateAnimation("Translation")
        icon.slideAnim:SetDuration(0.15)
        frame.icons[i] = icon
    end
    frame.order = { frame.icons[1], frame.icons[2], frame.icons[3], frame.icons[4] }
    frame.icons[1].slideGroup:SetScript("OnFinished", function()
        Util.SettleCastTrackerIcons(frame)
    end)
    Util.ResizeCastTrackerIcons(frame, iconSize)
end

-- Anchors every icon to its resting slot (left, center, right, hidden entry) based on its place in frame.order
function Util.PositionCastTrackerIcons(frame)
    local offsets = { -frame.iconSize, 0, frame.iconSize, frame.iconSize * 2 }
    for i, icon in ipairs(frame.order) do
        icon:ClearAllPoints()
        icon:SetPoint("CENTER", frame, "CENTER", offsets[i], 0)
    end
end

function Util.ResizeCastTrackerIcons(frame, iconSize)
    frame.iconSize = iconSize
    for _, icon in ipairs(frame.icons) do
        icon:SetSize(iconSize, iconSize)
        icon.slideAnim:SetOffset(-iconSize, 0)
    end
    Util.PositionCastTrackerIcons(frame)
end

-- Retires the icon that just slid out to the left and parks it back in the hidden entry slot
function Util.SettleCastTrackerIcons(frame)
    table.insert(frame.order, table.remove(frame.order, 1))
    Util.PositionCastTrackerIcons(frame)
end

-- Loads the new spell into the hidden slot and slides the whole queue left; fast-forwards any shift already in progress
function Util.PushCastTrackerIcon(frame, texture)
    if frame.icons[1].slideGroup:IsPlaying() then
        for _, icon in ipairs(frame.icons) do
            icon.slideGroup:Stop()
        end
        Util.SettleCastTrackerIcons(frame)
    end
    frame.order[4]:SetTexture(texture)
    for _, icon in ipairs(frame.icons) do
        icon.slideGroup:Play()
    end
end