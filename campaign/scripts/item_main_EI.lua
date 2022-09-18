--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local function getItemTypes()
	local tTypes = {
		['weapon'] = false,
		['armor'] = false,
		['wand'] = false,
		['staff'] = false,
		['wondrous%sitem'] = false,
		['shield'] = false,
	};

	for s, _ in pairs(tTypes) do
		tTypes[s] = (type.getValue() .. subtype.getValue()):lower():match(s) ~= nil;
	end

	return tTypes
end

local function sectionVis(tSections)
	for k, v in ipairs(tSections) do
		local num, bool = k, nil;
		if k > 2 then
			repeat
				num = num - 1;
				bool = tSections[num] or bool;
			until num == 1;

			if self['divider' .. tostring(k - 1)] then self['divider' .. tostring(k - 1)].setVisible(v and bool); end
		elseif k == 2 then
			if self['divider'] then self['divider'].setVisible(v and tSections[k - 1]); end
		end
	end
end

-- luacheck: globals update
function update(...)
	if super and super.update then super.update(...); end

	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState("item", nodeRecord);

	local tSections = {}

	if Session.IsHost then
		if self.updateControl("nonid_name", bReadOnly, true) then tSections[1] = true; end;
	else
		self.updateControl("nonid_name", false);
	end
	if (Session.IsHost or not bID) then
		if self.updateControl("nonidentified", bReadOnly, true) then tSections[1] = true; end;
	else
		self.updateControl("nonidentified", false);
	end

	if self.updateControl("type", bReadOnly, bID) then tSections[2] = true; end
	if self.updateControl("subtype", bReadOnly, bID) then tSections[2] = true; end

	if Session.IsHost then
		if self.updateControl("cost", bReadOnly, bID) then tSections[3] = true; end
	else
		if self.updateControl('cost', bReadOnly, bID and (cost_visibility.getValue() == 0)) then tSections[3] = true; end
	end
	if self.updateControl("weight", bReadOnly, bID) then tSections[3] = true; end
	if self.updateControl('size', bReadOnly, bID) then tSections[3] = true; end

	local tTypes = getItemTypes();
	tSections[4] = true;
	if Session.IsHost or bID then
		if tTypes['shield'] then
			type_stats.setValue("item_main_armor", nodeRecord);
			type_stats2.setValue("item_main_weapon", nodeRecord);
		elseif tTypes['weapon'] then
			type_stats.setValue("item_main_weapon", nodeRecord);
			type_stats2.setValue("", "");
		elseif tTypes['armor'] then
			type_stats.setValue("item_main_armor", nodeRecord);
			type_stats2.setValue("", "");
		else
			type_stats.setValue("", "");
			type_stats2.setValue("", "");
			tSections[4] = false;
		end
	else
		type_stats.setValue("", "");
		tSections[4] = false;
	end
	type_stats.update(bReadOnly, bID);
	type_stats2.update(bReadOnly, bID);

	if self.updateControl('charge', bReadOnly, bID and (tTypes['wand'] or tTypes['staff'])) then
		maxcharges.setReadOnly(bReadOnly);
		charge.setReadOnly(false);
		current_label.setVisible(true);
		maxcharges.setVisible(true);
		maxcharges_label.setVisible(true);
	else
		current_label.setVisible(false);
		maxcharges.setVisible(false);
		maxcharges_label.setVisible(false);
	end

	if self.updateControl('equipslot', bReadOnly, bID and tTypes['wondrous%sitem']) then tSections[4] = true; end

	if self.updateControl("aura", bReadOnly, bID) then tSections[5] = true; end
	if self.updateControl("cl", bReadOnly, bID) then tSections[5] = true; end
	if self.updateControl("prerequisites", bReadOnly, bID) then tSections[5] = true; end
	if self.updateControl("activation", bReadOnly, bID and (
							tTypes['shield'] or tTypes['armor'] or tTypes['staff'] or tTypes['wondrous%sitem']
						)) then tSections[5] = true; end

	tSections[6] = bID;
	description.setVisible(bID);
	description.setReadOnly(bReadOnly);
	self.updateControl('sourcebook', bReadOnly, bID);
	if self.updateControl('gmonly', bReadOnly, bID) then
		gmonly.setVisible(Session.IsHost);
		gmonly_label.setVisible(Session.IsHost);
	end

	sectionVis(tSections)
end
