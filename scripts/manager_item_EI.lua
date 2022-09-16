--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals ItemManager.isArmor ItemManager.isShield ItemManager.isWeapon

local contains_old;
local function contains(tList, sItem)
	if not tList or not sItem then
		return false;
	end
	for i = 1, #tList do
		if sItem:match(tList[i]) then
			return true;
		end
	end
	return false;
end

local isArmor_old;
local function isArmor(nodeItem, ...)
	StringManager.contains = contains;
	local bReturn = isArmor_old(nodeItem, ...);
	StringManager.contains = contains_old;

	return bReturn;
end

local isShield_old;
local function isShield(nodeItem, ...)
	StringManager.contains = contains;
	local bReturn = isShield_old(nodeItem, ...);
	StringManager.contains = contains_old;

	return bReturn;
end

local isWeapon_old;
local function isWeapon(nodeItem, ...)
	StringManager.contains = contains;
	local bReturn = isWeapon_old(nodeItem, ...);
	StringManager.contains = contains_old;

	return bReturn;
end

function onInit()
	contains_old = StringManager.contains

	isArmor_old = ItemManager.isArmor
	ItemManager.isArmor = isArmor;
	isShield_old = ItemManager.isShield
	ItemManager.isShield = isShield;
	isWeapon_old = ItemManager.isWeapon
	ItemManager.isWeapon = isWeapon;
end