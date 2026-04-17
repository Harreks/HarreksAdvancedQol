local _, NS = ...
local Data = NS.Data
local Util = NS.Util
local Core = NS.Core

Data.settings = {
    {
        key = 'generalHeader',
        type = 'header',
        text = 'General'
    },
    {
        key = "screenshotMessage",
        type = "checkbox",
        text = "Display Screenshot Message",
        default = false,
        tooltip = "Enable or disable the 'Screen Captured' Text that shows after taking a screenshot.",
        func = "ToggleScreenshotMessage"
    },
    {
        key = "maxCameraDistance",
        type = "slider",
        text = "Max Camera Distance",
        min = 1,
        max = 2.6,
        step = 0.1,
        default = 2.6,
        tooltip = "Controls the maximum zoom out distance.",
        func = "MaxCameraDistance"
    },
    {
        key = "showCoordinates",
        type = "checkbox",
        text = "Show Coordinates",
        default = false,
        tooltip = "Show your current coordinates on the top right of the minimap.",
        func = "ShowCoordinates"
    },
    {
        key = "waypointCommand",
        type = "checkbox",
        text = "Enable /way Command",
        default = false,
        tooltip = "Enables the '/way x y' command to create native waypoints. (Turning this off might require a reload to fix conflicts with other addons)",
        func = "WaypointCommand"
    },
    {
        key = "lowFoodReminder",
        ddKey = "chosenFood",
        type = "checkbox-dropdown",
        text = "Low On Food Reminder",
        default = false,
        ddDefault = 260260,
        items = {
            { text = "Springrunner Sparkling", value = 260260 },
            { text = "Bloom Nectar", value = 260261 },
            { text = "Sanguithorn Tea", value = 242299 }
        },
        tooltip = "Shows a warning while inside Silvermoon city if you are low on your chosen food.",
        func = "LowFoodReminder"
    },
    {
        key = 'automationHeader',
        type = 'header',
        text = 'Automation'
    },
    {
        key = "autoCombatLog",
        type = "checkbox",
        text = "Enable Auto Combat Log",
        default = true,
        tooltip = "Enable automatically starting the combat log when you log in to the game.",
        func = "ToggleCombatLogging"
    },
    {
        key = "autoSellAndRepair",
        type = "checkbox",
        text = "Auto Sell and Repair",
        default = false,
        tooltip = "Enable to automatically sell junk and repair when interacting with an npc.",
        func = "AutoSellAndRepair"
    },
    {
        key = 'autoAcceptRoleQueue',
        type = 'checkbox',
        text = 'Auto Accept Role Queues',
        default = false,
        tooltip = 'Enable to automatically accept role queues with your last selected role.',
        func = 'AutoAcceptRoleQueues'
    },
    {
        key = 'unitFramesHeader',
        type = 'header',
        text = 'Unit Frames'
    },
    {
        key = "playerCombatText",
        type = "checkbox",
        text = "Player Combat Text",
        default = false,
        tooltip = "Toggles the combat text numbers that show on the player frame.",
        func = "TogglePlayerCombatText"
    },
    {
        key = "totemFrame",
        type = "checkbox",
        text = "Display Totems Frame",
        default = false,
        tooltip = "Show or hide the totems frame that appears below the player frame.",
        func = "ToggleTotemFrame"
    },
    {
        key = "essenceFrame",
        type = "checkbox",
        text = "Display Essence Frame",
        default = false,
        tooltip = "Show or hide the essence icons that show below the player frame.",
        func = "ToggleEssenceFrame"
    },
    {
        key = "targetInfoAnchors",
        type = "checkbox",
        text = "Target Info on the Right",
        default = true,
        tooltip = "By default, the TargetOfTarget and Target Castbar show below the target, this settings anchors them on the right instead.",
        func = "TargetInfoAnchors"
    },
    {
        key = 'castBarHeader',
        type = 'header',
        text = 'Cast Bar'
    },
    {
        key = "castTimeInside",
        type = "checkbox",
        text = "Cast Time Inside",
        default = true,
        tooltip = "Displays the cast time inside the cast bar.",
        func = "MoveCastBarTime"
    },
    {
        key = "castBarIcon",
        type = "checkbox",
        text = "Show Cast Bar Icon",
        default = true,
        tooltip = "Displays the spell icon next to the cast bar.",
        func = "CastBarIcon"
    },
    {
        key = 'combatTimerHeader',
        type = 'header',
        text = 'Combat Timer'
    },
    {
        key = "combatTimer",
        type = "checkbox",
        text = "Enable Combat Timer",
        default = false,
        tooltip = "Uses the in game stopwatch as an automatic combat timer.",
        func = "CombatTimer"
    },
    {
        key = "combatTimerScale",
        type = "slider",
        text = "Stopwatch Scale",
        min = 0.5,
        max = 3,
        step = 0.1,
        default = 1,
        tooltip = "Scale of the stopwatch timer.",
        parent = "combatTimer",
        func = "CombatTimerScale"
    },
    {
        key = 'castTrackerHeader',
        type = 'header',
        text = 'Cast Tracker'
    },
    {
        key = "castTracker",
        type = "checkbox",
        text = "Enable Cast Tracker",
        default = false,
        tooltip = "Enable a small cast tracker that shows the icons of your last 3 spell casts.",
        func = "EnableCastTracker"
    },
    {
        key = "lockCastTracker",
        type = "checkbox",
        text = "Lock Cast Tracker",
        default = true,
        tooltip = "Lock and unlock the cast tracker for repositioning.",
        parent = "castTracker",
        func = "LockCastTracker"
    },
    {
        key = "castTrackerIconSize",
        type = "slider",
        text = "Cast Tracker Icon Size",
        min = 15,
        max = 80,
        step = 1,
        default = 50,
        tooltip = "Size of the icons in the cast tracker.",
        parent = "castTracker",
        func = "CastTrackerIconSize"
    }
}

Data.targetCastbarHooked = false
Data.totemFrameHooked = false
Data.essenceFrameHooked = false