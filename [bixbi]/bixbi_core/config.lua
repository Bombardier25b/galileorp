Config = {}

Config.NotifyType = "mythic_notify" -- Options = t-notify, esx, mythic_notify, okokNotify
Config.LoadingType = "mythic" -- Options = mythic, pogress, none
Config.OxInventory = true -- When true, ox inventory related exports will work.

Config.IllegalTaskBlacklist = {
    -- Jobs in here cannot perform illegal tasks, if the script checks for it. Such as drug collection / selling.
    police = {},
    ambulance = {},
    mechanic = {}
}
