extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel

var item = null

func _on_item_button_pressed() -> void:
	if item != null:
		usage_panel.visible = !usage_panel.visible
	pass # Replace with function body.


func _on_item_button_mouse_entered() -> void:
	if item != null:
		usage_panel.visibile = false
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
	print("Placing item in slot:", item.name, "qty:", quantity)
