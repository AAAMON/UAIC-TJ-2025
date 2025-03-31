extends Node

var hp : int = 100
var max_hp : int = 100
var inventory : Array = []
var equipped_weapon : String = ""

func add_to_inventory(item: String):
	inventory.append(item)

func remove_from_inventory(item: String):
	inventory.erase(item)

func equip_weapon(weapon: String):
	equipped_weapon = weapon

func heal(amount: int):
	hp = min(hp + amount, max_hp)

func take_damage(amount: int):
	hp = max(hp - amount, 0)
