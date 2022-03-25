-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
function onInit() update(); end

function VisDataCleared() update(); end

function InvisDataAdded() update(); end

function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then return false; end

	if not bID then return self[sControl].update(bReadOnly, true); end

	return self[sControl].update(bReadOnly);
end

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

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID, bOptionID = ItemManager.getIDState(nodeRecord);

	local bWeapon, bArmor, bShield, bWand, bStaff, bWondrous = getItemType();

	local bSection1 = false;
	if bOptionID and Session.IsHost then
		if updateControl('nonid_name', bReadOnly, true) then bSection1 = true; end
	else
		updateControl('nonid_name', false);
	end
	if bOptionID and (Session.IsHost or not bID) then
		if updateControl('nonidentified', bReadOnly, true) then bSection1 = true; end
	else
		updateControl('nonidentified', false);
	end

	local bSection2 = false;
	if updateControl('type', bReadOnly, bID) then bSection2 = true; end
	if updateControl('subtype', bReadOnly, bID) then bSection2 = true; end

	local bSection3 = false;
	if updateControl('cost', bReadOnly, bID) then bSection3 = true; end
	if updateControl('weight', bReadOnly, bID) then bSection3 = true; end
	if updateControl('size', bReadOnly, bID) then bSection3 = true; end

	local bSection4 = false;
	if updateControl('damage', bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl('damagetype', bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl('critical', bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl('range', bReadOnly, bID and bWeapon) then bSection4 = true; end

	if updateControl('ac', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('maxstatbonus', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('checkpenalty', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('spellfailure', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('speed30', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('speed20', bReadOnly, bID and bArmor) then bSection4 = true; end

	if updateControl('charge', bReadOnly, bID and (bWand or bStaff)) then
		bSection4 = true;
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

	if updateControl('equipslot', bReadOnly, bID and bWondrous) then bSection4 = true; end

	if updateControl('properties', bReadOnly, bID and (bWeapon or bArmor)) then bSection4 = true; end

	local bSection5 = false;
	if updateControl('bonus', bReadOnly, bID and (bWeapon or bArmor)) then bSection5 = true; end
	if updateControl('aura', bReadOnly, bID) then bSection5 = true; end
	if updateControl('cl', bReadOnly, bID) then bSection5 = true; end
	if updateControl('prerequisites', bReadOnly, bID) then bSection5 = true; end

	local bSection6 = bID;
	description.setVisible(bID);
	description.setReadOnly(bReadOnly);
	updateControl('sourcebook', bReadOnly, bID);

	local bSection7 = false;
	divider6.setVisible(false);
	gmonly_label.setVisible(false);
	gmonly.setVisible(false);

	if Session.IsHost then if updateControl('gmonly', bReadOnly, bOptionID) then bSection7 = true; end end
	if Session.IsHost then divider6.setVisible((bSection1 or bSection2 or bSection3 or bSection4 or bSection5) and bSection7); end

	divider.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
	divider4.setVisible((bSection1 or bSection2 or bSection3 or bSection4) and bSection5);
	divider5.setVisible((bSection1 or bSection2 or bSection3 or bSection4 or bSection5) and bSection6);
end
