-- ItemStatPercentages
local addonName, addonTable = ...
local L = addonTable.L

-- defaults for saved variables
local defaults = { colour =  "|cFFFF78CC" }
local saved = ItemStatPercentagesDB or defaults

-- localized functions
local select, GetMasteryEffect, print, tonumber = select, GetMasteryEffect, print, tonumber
local find, gsub, match = string.find, string.gsub, string.match

-- Name of each stat, localized
local StatNames = {
		Mastery  = RAID_BUFF_7,
		Haste = RAID_BUFF_4,
		Crit = RAID_BUFF_6,
		Vers = RAID_BUFF_8,
    Enchanted = string.sub(ENCHANTED_TOOLTIP_LINE, 1, string.len(ENCHANTED_TOOLTIP_LINE) - 3)
}

-- Value of each stat
local StatValues = {
	Crit = 400,
	Haste = 375,
	Vers = 475,
	Mastery = 400
}

-- color of the tip percentage
local pCol = saved.colour
local debug = false

-- Print function
local message = function(msg)
	if debug then print(msg) end
end

-- Generic round function
local round = function(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- Get percentage of stat from stat value
local getPercentage = function(statid, stat)
	if not stat then return end
	local p = round(stat / StatValues[statid], 1)
	return pCol.."("..p.."%)\124r"
end

-- Initialize mastery
local initMastery = function()
	StatValues.Mastery = 400 / select(2, GetMasteryEffect())
	message("\124cffffdd00"..L["StatValues"].."\124r.\124cffdd00ff"..StatNames.Mastery.."\124r = \124cffffff00"..StatValues.Mastery.."\124r")
end

-- Set value
local set = function(t, str)
	if t and str then
		t:SetText(str)
	end
end

-- Main function, scap the tooltip
local UpdateTip = function(_tip)
	-- Fetch tip from global scope
	local tip = _G[_tip]
	-- Check if tip is real, otherwise abort
	--if not tip then return end
	if tip then
		-- Get tooltip if tip is an item
		local name = tip:GetItem()
		-- Check if name exists, otherwise abort
		--if not name then return end
		-- Iterate the tooltip lines
		local lines = tip:NumLines() -- Get line count
		for i = 1, lines do -- Iterate lines of tooltip
			local text = _G[_tip.."TextLeft"..i] -- Check left text
			--local text = _G[_tip.."TextRight"..i] -- Check right text
			-- Check if text exists, otherwise abort
			if text then
				local _text = text:GetText() -- get text from line
				-- Check if _text exists, otherwise abort
				--if not _text then return end
				-- Save the regular tooltip text
				local _textbak = _text
				-- Text is valid, look for stats
				local crit =     find(_text, StatNames.Crit)
				local haste =    find(_text, StatNames.Haste)
				local vers =     find(_text, StatNames.Vers)
				local mastery =  find(_text, StatNames.Mastery)
				-- Clean up the string by replaceing everything with an empty string
				_text = gsub(_text, StatNames.Crit, "") -- replace 'Critical Strike'
				_text = gsub(_text, StatNames.Haste, "")	-- replace 'Haste'
				_text = gsub(_text, ",", "") -- replace comma
				_text = gsub(_text, " ", "") -- replace space
				_text = gsub(_text, StatNames.Vers, "") -- replace 'Versatility'
				_text = gsub(_text, StatNames.Mastery, "") -- replace 'Mastery'
				_text = gsub(_text, "+", "") -- replace '+'
				_text = gsub(_text, StatNames.Enchanted, "") -- replace 'Enchanted'
				--print('testing',_text)
				if crit then
					local perc = getPercentage("Crit", tonumber(_text))
					--if not perc then return end
					if perc then
						local newstring = _textbak.." "..perc
						if not find(_textbak, perc) then set(text, newstring) end
					end
				elseif haste then
					local perc = getPercentage("Haste", tonumber(_text))
					--if not perc then return end
					if perc then
						local newstring = _textbak.." "..perc
						if not find(_textbak, perc) then set(text, newstring) end
					end
				elseif vers then
					local perc = getPercentage("Vers", tonumber(_text))
					--if not perc then return end
					if perc then
						local newstring = _textbak.." "..perc
						if not find(_textbak, perc) then set(text, newstring) end
					end
				elseif mastery then
					local perc = getPercentage("Mastery", tonumber(_text))
					--if not perc then return end
					if perc then
						local newstring = _textbak.." "..perc
						if not find(_textbak, perc) then set(text, newstring) end
					end
				end
			end
		end
	end
	tip:Show()
end


-- Frame creation and setup
local f = CreateFrame('frame')
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("PLAYER_LOGOUT")
f:SetScript("OnEvent", function(self,event, addon)
	if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		initMastery()
	elseif event == "ADDON_LOADED" and addon == addonName then
		saved = ItemStatPercentagesDB or defaults
		pCol = saved.colour
		message(string.format("loaded colour: %shere\124r", pCol))
	else
		-- logged out, save variables
		ItemStatPercentagesDB = {colour=pCol}
	end
end)

-- Update on every frame
f:SetScript("OnUpdate", function(self)
	-- Check tooltips
	UpdateTip("GameTooltip")
	UpdateTip("ShoppingTooltip1")
	UpdateTip("ShoppingTooltip2")
	UpdateTip("ItemRefTooltip")
end)

SLASH_ISP1, SLASH_ISP2 = '/isp', '/itemstatpercentages'
function SlashCmdList.ISP(msg, editbox)
  if msg == "" then print(L["\124cffff0000Error:\124r usage is: /isp [#hex]"]) return end
	if msg == "default" then pCol = "|cFFFF78CC"; print(string.format(L["\124cffffff00ISP colour set to:\124r %sthis\124r"], pCol)) return end
  if msg:len() ~= 7 then print(L["\124cffff0000Error:\124r usage is: /isp [#hex]"]) return end
	if msg:sub(1, 1) ~= "#" then print(L["\124cffff0000Error:\124r usage is: /isp [#hex]"]) return end
	local prefix = "\124cFF"
	local hex = string.sub(msg, 2, msg:len())
	pCol = prefix .. hex
	print(string.format(L["\124cffffff00ISP colour set to:\124r %sthis\124r"], pCol))
end
