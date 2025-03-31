extends Node

var hp : int = 100
var max_hp : int = 100
var inventory : Array = []
var equipped_weapon : String = ""

func add_to_inventory(item_id: String):
	for i in inventory.size():
		if inventory[i][0] == item_id:
			inventory[i] = [item_id, inventory[i][1] + 1]
			return
	inventory.append([item_id, 1])

func remove_from_inventory(item_id: String):
	for i in inventory.size():
		if inventory[i][0] == item_id:
			if inventory[i][1] > 1:
				inventory[i] = [item_id, inventory[i][1] - 1]
			else:
				inventory.remove_at(i)
			return

func equip_weapon(weapon: String):
	equipped_weapon = weapon

func heal(amount: int):
	hp = min(hp + amount, max_hp)

func take_damage(amount: int):
	hp = max(hp - amount, 0)
