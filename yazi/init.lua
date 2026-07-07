local SIZE_WIDTH = 7
local DEFAULT_DATE_WIDTH = 11
local YYYY_DATE_WIDTH = 10
local YY_DATE_WIDTH = 8

-- Always overridden in custom mode
local date_format = "%m.%d.%Y"
local date_width = DEFAULT_DATE_WIDTH

local custom_date = true

local original_mtime = Linemode.mtime
local original_btime = Linemode.btime

-- _is_today
local function _is_today(time)
	local date = os.date("*t", time)
	local today = os.date("*t")

	return date.year == today.year and date.month == today.month and date.day == today.day
end

-- _format_date
local function _format_date(ts)
	local time = math.floor(ts or 0)
	if time == 0 then
		return ""
	elseif _is_today(time) then
		return os.date("%R", time)
	else
		return os.date(date_format, time)
	end
end

-- Linemode:btime
function Linemode:btime()
	if custom_date then
		return _format_date(self._file.cha.btime)
	else
		return original_btime(self)
	end
end

-- Linemode:mtime
function Linemode:mtime()
	if custom_date then
		return _format_date(self._file.cha.mtime)
	else
		return original_mtime(self)
	end
end

-- Linemode:size_mtime
function Linemode:size_mtime()
	local format_str = "%" .. SIZE_WIDTH .. "s  %" .. date_width .. "s"
	return string.format(format_str, self:size(), self:mtime())
end

-- ya.readable_size
function ya.readable_size(size)
	local units = { "B", "K", "M", "G", "T", "P", "E", "Z", "Y", "R", "Q" }
	local i = 1
	while size > 1024 and i < #units do
		size = size / 1024
		i = i + 1
	end
	local s = string.format("%.1f%s", size, " " .. units[i]):gsub("[.,]0", "", 1)
	return s
end
