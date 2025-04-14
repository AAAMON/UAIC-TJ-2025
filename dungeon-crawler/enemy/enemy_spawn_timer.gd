extends Timer
class_name EnemySpawnTimer

@export var to_instantiate: Resource

@onready var nav_region: NavigationRegion3D = $"../../NavigationRegion3D"

func _ready():
	autostart = true
	connect(&"timeout", _on_timeout)

func _on_timeout():
	var instance = to_instantiate.instantiate()
	instance.position = Utils.rand_choice(
		get_tree().get_nodes_in_group("enemy spawns")
	).global_position
	nav_region.add_child(instance)
