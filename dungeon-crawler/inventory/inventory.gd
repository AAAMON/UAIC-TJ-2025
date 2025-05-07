extends Control
const MAX_SLOTS := 18

@onready var grid_container = $GridContainer

func _ready():
	global.inventory_updated.connect(_on_inventory_updated)
	_create_empty_slots()
	_on_inventory_updated()
	
func _create_empty_slots():
	for child in grid_container.get_children():
		child.queue_free()
	for i in range(MAX_SLOTS):
		var slot = global.inventory_slot_scene.instantiate()
		slot.set_empty()
		grid_container.add_child(slot)
			
func _on_inventory_updated():
	var slots = grid_container.get_children()

	# First clear all
	for slot in slots:
		slot.set_empty()

	var i = 0
	for item_data in global.inventory:
		if item_data == null:
			continue  # skip bad item
		var quantity = global.inventory[item_data]
		if quantity <= 0:
			continue
		slots[i].set_item(item_data, quantity)
		i += 1


func clear_grid_container():
	for child in grid_container.get_children():
		child.queue_free()
