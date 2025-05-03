extends Node

var max_hp: int = 100
var hp: int = max_hp
var inventory: Dictionary[ItemData, int] = {}
var equipped_weapon: ItemData = null
var player_node: Node = null

@onready var inventory_slot_scene = preload("res://inventory/inventory_slot.tscn")

signal inventory_updated

func _ready() -> void:
	pass

func add_item(item_data):
	if inventory.has(item_data):
		inventory[item_data] += 1
	else:
		inventory[item_data] = 1
	
	print("Added item:", item_data.name, "Quantity:", inventory[item_data])
	inventory_updated.emit()

	
func remove_item(item_type, item_effect):
	for item_data in inventory.keys():
		if item_data.type == item_type and item_data.effect == item_effect:
			inventory[item_data] -= 1
			if inventory[item_data] <= 0:
				inventory.erase(item_data)
			inventory_updated.emit()
			return true
	return false

func increase_inventory_size():
	inventory_updated.emit()
	
func set_player_reference(player):
	player_node = player
	
func add_to_inventory(item: ItemData, count: int=1):
	if item in inventory:
		inventory[item] += count
	else:
		inventory[item] = count

func remove_from_inventory(item: ItemData, remove_stack: bool=true):
	if item not in inventory: return
	if remove_stack or inventory[item] == 1:
		inventory.erase(item)
	else:
		inventory[item] -= 1

func equip_weapon(item: ItemData):
	equipped_weapon = item

func heal(amount: int):
	hp = min(hp + amount, max_hp)

func take_damage(amount: int):
	hp = max(hp - amount, 0)
