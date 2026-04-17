local _, NS = ...
local Data = NS.Data
local Util = NS.Util
local Core = NS.Core

-- Initialize layout states
local totemPoint, totemParent, totemRel, totemX, totemY = TotemFrame:GetPoint()
local totPoint, totParent, totRel, totX, totY = TargetFrameToT:GetPoint()

-- State vars
Data.targetCastbarHooked = false
Data.actionBarButtonList = {}
for i = 6, 7 do
    for j = 1, 12 do
        local button = 'MultiBar' .. i .. 'Button' .. j
        table.insert(Data.actionBarButtonList, button)
    end
end
