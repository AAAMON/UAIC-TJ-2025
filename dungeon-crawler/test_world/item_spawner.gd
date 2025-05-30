extends Node3D

@export var item_scene: PackedScene
@export var number_of_items := 1000
@export var spawn_radius := 20.0

func _ready():
	randomize()

	for i in range(number_of_items):
		var item_instance = item_scene.instantiate()
		var offset = Vector3(
			randf_range(-spawn_radius, spawn_radius),
			0,
			randf_range(-spawn_radius, spawn_radius)
		)

		get_tree().current_scene.add_child.call_deferred(item_instance)
		item_instance.set_deferred("global_position", global_position + offset)
