local _, NS = ...
local L = NS.L
if GetLocale() ~= "enDE" then return end
L = {}
L["StatValues"] = "Wertebetrag"
L["\124cffff0000Error:\124r usage is: /isp [#hex]"] = "\124cffff0000Fehler:\124r Nutzung von: /isp [#hex]"
L["\124cffffff00ISP colour set to:\124r %sthis\124r"] = "\124cffffff00ISP Farbe gesetzt auf: \124r %sthis\124r"
NS.L = L
