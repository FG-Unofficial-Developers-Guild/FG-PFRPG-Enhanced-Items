--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals subtype

local function getItemTypes()
	local tTypes = {
		["weapon"] = false,
		["armor"] = false,
		["wand"] = false,
		["staff"] = false,
		["wondrous%sitem"] = false,
		["shield"] = false,
	}

	for s, _ in pairs(tTypes) do
		tTypes[s] = (type.getValue() .. subtype.getValue()):lower():match(s) ~= nil
	end

	return tTypes
end

local function setSectionVis(nDivNum, bool)
	local sDivName = "divider" .. tostring(nDivNum)
	local bVis = self[sDivName] and (self[sDivName].getVisible and not self[sDivName].getVisible())
	if bVis then
		self[sDivName].setVisible(bool)
	end
end

local function sectionVis(tSections)
	for k, v in ipairs(tSections) do
		local num, bool = k, nil
		if k == 2 then
			setSectionVis("", v and tSections[k - 1])
		elseif k > 2 then
			repeat
				num = num - 1
				bool = tSections[num] or bool
			until num == 1

			setSectionVis(k - 1, v and bool)
		end
	end
end

-- luacheck: globals onStateChanged type_stats2 type_stats2.setValue type_stats2.update
function onStateChanged(...)
	if super and super.onStateChanged then
		super.onStateChanged(...)
	end

	local nodeRecord = getDatabaseNode()
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord)
	local bID = LibraryData.getIDState("item", nodeRecord)

	local tSections = {}

	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly) then
			tSections[1] = true
		end
	else
		WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly, true)
	end
	if Session.IsHost or not bID then
		if WindowManager.callSafeControlUpdate(self, "nonidentified", bReadOnly) then
			tSections[1] = true
		end
	else
		WindowManager.callSafeControlUpdate(self, "nonidentified", bReadOnly, true)
	end

	if WindowManager.callSafeControlUpdate(self, "type", bReadOnly, not bID) then
		tSections[2] = true
	end
	if WindowManager.callSafeControlUpdate(self, "subtype", bReadOnly, not bID) then
		tSections[2] = true
	end

	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, "cost", bReadOnly, not bID) then
			tSections[3] = true
		end
	else
		if
			WindowManager.callSafeControlUpdate(
				self,
				"cost",
				bReadOnly,
				not (bID and (cost_visibility.getValue() == 0))
			)
		then
			tSections[3] = true
		end
	end
	if WindowManager.callSafeControlUpdate(self, "weight", bReadOnly, not bID) then
		tSections[3] = true
	end
	if WindowManager.callSafeControlUpdate(self, "size", bReadOnly, not bID) then
		tSections[3] = true
	end

	local tTypes = getItemTypes()
	tSections[4] = true
	if Session.IsHost or bID then
		if tTypes["shield"] then
			type_stats.setValue("item_main_armor", nodeRecord)
			type_stats2.setValue("item_main_weapon", nodeRecord)
		elseif tTypes["weapon"] then
			type_stats.setValue("item_main_weapon", nodeRecord)
			type_stats2.setValue("", "")
		elseif tTypes["armor"] then
			type_stats.setValue("item_main_armor", nodeRecord)
			type_stats2.setValue("", "")
		elseif tTypes["wand"] then
			type_stats.setValue("item_main_wand", nodeRecord)
			type_stats2.setValue("", "")
		elseif tTypes["staff"] then
			type_stats.setValue("item_main_weapon", nodeRecord)
			type_stats2.setValue("item_main_wand", nodeRecord)
		else
			type_stats.setValue("", "")
			type_stats2.setValue("", "")
			tSections[4] = false
		end
	else
		type_stats.setValue("", "")
		type_stats2.setValue("", "")
		tSections[4] = false
	end
	type_stats.update(bReadOnly, bID)
	type_stats2.update(bReadOnly, bID)

	if WindowManager.callSafeControlUpdate(self, "equipslot", bReadOnly, not (bID and tTypes["wondrous%sitem"])) then
		tSections[4] = true
	end
	if WindowManager.callSafeControlUpdate(self, "aura", bReadOnly, not bID) then
		tSections[5] = true
	end
	if WindowManager.callSafeControlUpdate(self, "cl", bReadOnly, not bID) then
		tSections[5] = true
	end
	if WindowManager.callSafeControlUpdate(self, "prerequisites", bReadOnly, not bID) then
		tSections[5] = true
	end
	if
		WindowManager.callSafeControlUpdate(
			self,
			"activation",
			bReadOnly,
			not (bID and (tTypes["shield"] or tTypes["armor"] or tTypes["staff"] or tTypes["wondrous%sitem"]))
		)
	then
		tSections[5] = true
	end

	tSections[6] = bID
	description.setVisible(bID)
	description.setReadOnly(bReadOnly)
	WindowManager.callSafeControlUpdate(self, "sourcebook", bReadOnly, not bID)
	if WindowManager.callSafeControlUpdate(self, "gmonly", bReadOnly, not bID) then
		gmonly.setVisible(Session.IsHost)
		gmonly_label.setVisible(Session.IsHost)
	end

	sectionVis(tSections)
end
