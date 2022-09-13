--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals update getItemType

function getItemType()
	local bWeapon, bArmor, bShield, bWand, bStaff, bWondrous;
	local sType = string.lower(type.getValue());
	local sSubtype = string.lower(subtype.getValue());

	if sType:match('weapon') then bWeapon = true; end
	if sType:match('armor') then bArmor = true; end
	if sType:match('wand') then bWand = true; end
	if sType:match('staff') then bStaff = true; end
	if sType:match('wondrous item') then bWondrous = true; end
	if sType:match('shield') or sSubtype:match('shield') then bShield = true; end

	return bWeapon, bArmor, bShield, bWand, bStaff, bWondrous;
end

function update(...)
	if super and super.update then super.update(...); end

	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState("item", nodeRecord);

	local bWeapon, bArmor, bShield, bWand, bStaff, bWondrous = getItemType();

	local bSection1 = false;
	if Session.IsHost then
		if self.updateControl("nonid_name", bReadOnly, true) then bSection1 = true; end;
	else
		self.updateControl("nonid_name", false);
	end
	if (Session.IsHost or not bID) then
		if self.updateControl("nonidentified", bReadOnly, true) then bSection1 = true; end;
	else
		self.updateControl("nonidentified", false);
	end

	local bSection2 = false;
	if self.updateControl("type", bReadOnly, bID) then bSection2 = true; end
	if self.updateControl("subtype", bReadOnly, bID) then bSection2 = true; end

	local bSection3 = false;
	if Session.IsHost then
		if self.updateControl("cost", bReadOnly, bID) then bSection3 = true; end
	else
		if self.updateControl('cost', bReadOnly, bID and (cost_visibility.getValue() == 0)) then bSection3 = true; end
	end
	if self.updateControl("weight", bReadOnly, bID) then bSection3 = true; end
	if self.updateControl('size', bReadOnly, bID) then bSection3 = true; end

	local bSection4 = true;
	if Session.IsHost or bID then
		if bShield then
			type_stats.setValue("item_main_armor", nodeRecord);
			type_stats2.setValue("item_main_weapon", nodeRecord);
		elseif bWeapon then
			type_stats.setValue("item_main_weapon", nodeRecord);
		elseif bArmor then
			type_stats.setValue("item_main_armor", nodeRecord);
		else
			type_stats.setValue("", "");
			bSection4 = false;
		end
	else
		type_stats.setValue("", "");
		bSection4 = false;
	end
	type_stats.update(bReadOnly, bID);
	type_stats2.update(bReadOnly, bID);

	if self.updateControl('charge', bReadOnly, bID and (bWand or bStaff)) then
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

	if self.updateControl('equipslot', bReadOnly, bID and bWondrous) then bSection4 = true; end

	local bSection5 = false;
	if self.updateControl("aura", bReadOnly, bID) then bSection5 = true; end
	if self.updateControl("cl", bReadOnly, bID) then bSection5 = true; end
	if self.updateControl("prerequisites", bReadOnly, bID) then bSection5 = true; end
	if self.updateControl("activation", bReadOnly, bID and (bWeapon or bArmor or bShield or bWand or bStaff or bWondrous)) then bSection5 = true; end

	local bSection6 = bID;
	description.setVisible(bID);
	description.setReadOnly(bReadOnly);
	self.updateControl('sourcebook', bReadOnly, bID);
	if self.updateControl('gmonly', bReadOnly, bID) then
		gmonly.setVisible(Session.IsHost);
		gmonly_label.setVisible(Session.IsHost);
	end

	divider.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
	divider4.setVisible((bSection1 or bSection2 or bSection3 or bSection4) and bSection5);
	divider5.setVisible((bSection1 or bSection2 or bSection3 or bSection4 or bSection5) and bSection6);
end
