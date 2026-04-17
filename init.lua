--Initialize tables
local addonName, NS = ...
NS.Data = {}
NS.Util = {}
NS.Core = {}
NS.Version = C_AddOns.GetAddOnMetadata(addonName, 'Version')

--Initialize saved variables
HAQDB = HAQDB or {}
if HAQDB.version ~= NS.Version then
    HAQDB.version = NS.Version
end
