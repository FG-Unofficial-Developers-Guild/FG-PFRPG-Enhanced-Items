[![Build FG-Usable File](https://github.com/FG-Unofficial-Developers-Guild/FG-PFRPG-Enhanced-Items/actions/workflows/create-ext.yml/badge.svg)](https://github.com/FG-Unofficial-Developers-Guild/FG-PFRPG-Enhanced-Items/actions/workflows/create-ext.yml) [![Luacheck](https://github.com/FG-Unofficial-Developers-Guild/FG-PFRPG-Enhanced-Items/actions/workflows/luacheck.yml/badge.svg)](https://github.com/FG-Unofficial-Developers-Guild/FG-PFRPG-Enhanced-Items/actions/workflows/luacheck.yml)

# Enhanced Items
This extension modifies the item sheet to add some additional features like charges for wands and a gm-only notes field.
Original extension by [sciencephile](https://www.fantasygrounds.com/forums/member.php?23086-sciencephile) with updates by [jwguy](https://www.fantasygrounds.com/forums/member.php?26033-Jwguy), [llisandur](https://www.fantasygrounds.com/forums/member.php?61628-Llisandur), [rmilmine](https://www.fantasygrounds.com/forums/member.php?215591-rmilmine), and bmos.

# Compatibility
This extension has been tested with [FantasyGrounds Unity](https://www.fantasygrounds.com/home/FantasyGroundsUnity.php) 4.2.2 (2022-06-07).

# Features
This extension modifies the item sheet to add some additional features:

* Add GM-only field for tracking notes not visible to players.
* Wand / staff charges field
* Slot field for wondrous items
* Source field for tracking which book the information is from
* Weapon/Shield/Armor detection functions are now 'fuzzy' so "Armor" / "Armors" / "Armor and Defense" / etc will all detect as armor.

All of the type specific fields only display with the appropriate item type, the same as would originally happen with "Weapon" or "Armor" in the Type field. Additionally, I have fixed the problem where "Weapon" would show the additional fields, but "Magic Weapon" would not. Visibility of the type-specific fields depends on "Weapon", "Armor", "Wand", "Staff", or "Wondrous Item" exactly, with capitalization. Otherwise text before or after doesn't matter.

# Example Images
![example item sheets](https://user-images.githubusercontent.com/1916835/123555247-872b8b00-d752-11eb-95f0-db22c24091c2.jpg)
![source field](https://user-images.githubusercontent.com/1916835/123555249-898de500-d752-11eb-8edc-de8c7e0e15d9.jpg)
