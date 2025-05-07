extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $Details
@onready var item_name =$Details/DetailsPanel/ItemName
@onready var item_type = $Details/DetailsPanel/ItemType
@onready var item_effect = $Details/DetailsPanel/ItemEffect
@onready var usage_panel = $Usage

var item = null

func _on_item_button_pressed() -> void:
	if item != null:
		usage_panel.visible = !usage_panel.visible


func _on_item_button_mouse_entered() -> void:
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false
	
func set_empty():
	item = null
	if icon:
		icon.texture = null
	if quantity_label:
		quantity_label.text = ""
	if item_name:
		item_name.text = ""
	if item_type:
		item_type.text = ""
	if item_effect:
		item_effect.text = ""

	
func set_item(new_item, quantity):
	if new_item == null or quantity <= 0:
		set_empty()
		return
	item = new_item
	print("DEBUG: set_item() called")
	print("DEBUG: item.name =", item.name)
	print("DEBUG: item.texture =", item.texture)
	print("DEBUG: texture type =", typeof(item.texture))
	
	
	if icon and item.texture:
		icon.texture = item.texture
	if quantity_label:
		quantity_label.text = str(quantity)
	if item_name:
		item_name.text = item.name
	if item_type:
		item_type.text = item.type
	if item_effect:
		item_effect.text = item.description if item.description != "" else ""
	print("Placing item in slot:", item.name, " qty:", quantity)


func _on_drop_button_pressed() -> void:
	if item == null:
		return

	print("Dropping item:", item.name)

	# Spawn item in world if possible
	if global.player_node:
		var dropped = load("res://items/item.tscn").instantiate()
		dropped.item_data = item
		dropped.dropped = true
		dropped.global_position = global.player_node.global_position + Vector3(1, 1, 0)
		get_tree().current_scene.add_child(dropped)
	
	global.remove_from_inventory(item, false)
	usage_panel.visible = false
