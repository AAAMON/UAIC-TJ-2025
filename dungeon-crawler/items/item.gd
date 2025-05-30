extends Area3D

@export var item_data: ItemData
@export var time_until_despawn: float = 30.0

@onready var despawn_timer: Timer = $Timer
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var icon: TextureRect = $TextureRect

var player_in_range = false
var can_be_picked_up := false
var dropped := false

signal picked_up(item_data)

func _ready():
	# Apply icon texture to the mesh if available
	if item_data and item_data.texture:
		var mat = mesh.get_active_material(0)
		if mat and mat is StandardMaterial3D:
			var mat_instance = mat.duplicate()
			mat_instance.albedo_texture = item_data.texture

			# Enable glow
			mat_instance.emission_enabled = true
			mat_instance.emission = Color(0.4, 0.6, 1.0)  * 0.1  # White glow, adjust intensity
			mat_instance.emission_texture = item_data.texture  # optional, use same texture

			mesh.set_surface_override_material(0, mat_instance)
			

		# Assign the icon in the UI
		icon.texture = item_data.texture

	# Start despawn timer
	despawn_timer.wait_time = time_until_despawn
	despawn_timer.one_shot = true
	despawn_timer.start()
	despawn_timer.timeout.connect(_on_Timer_timeout)

	await get_tree().create_timer(0.5).timeout

	if dropped:
		await get_tree().create_timer(2).timeout
	can_be_picked_up = true


	# Connect body_entered signal to handle pickup
#	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if not can_be_picked_up:
		return
	if body.name == "Player":
		emit_signal("picked_up", item_data)
		global.add_item(item_data)
		despawn_timer.stop()
		queue_free()

func _on_Timer_timeout():
	queue_free()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false


func _on_timer_timeout() -> void:
	queue_free()
