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

function Util.AdjustTargetCastbarPosition()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPRIGHT", -5, -30)
end