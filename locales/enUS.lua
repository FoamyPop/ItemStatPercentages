local _, NS = ...
local L = NS.L
if L and GetLocale() ~= "enUS" then return end
L = {}
L["StatValues"] = "StatValues"
L["\124cffff0000Error:\124r usage is: /isp [#hex]"] = "\124cffff0000Error:\124r usage is: /isp [#hex]"
L["\124cffffff00ISP colour set to:\124r %sthis\124r"] = "\124cffffff00ISP colour set to:\124r %sthis\124r"
NS.L = L
