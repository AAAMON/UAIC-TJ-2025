extends Node

var max_hp: int = 100
var hp: int = max_hp
var inventory: Dictionary[String, int] = {}
var equipped_weapon: String = ""

func add_to_inventory(item_id: String, count: int=1):
	if item_id in inventory:
		inventory[item_id] += count
	else:
		inventory[item_id] = count

func remove_from_inventory(item_id: String, remove_stack: bool=true):
	if item_id not in inventory: return
	if remove_stack or inventory[item_id] == 1:
		inventory.erase(item_id)
	else:
		inventory[item_id] -= 1

func equip_weapon(weapon: String):
	equipped_weapon = weapon

func heal(amount: int):
	hp = min(hp + amount, max_hp)

func take_damage(amount: int):
	hp = max(hp - amount, 0)
