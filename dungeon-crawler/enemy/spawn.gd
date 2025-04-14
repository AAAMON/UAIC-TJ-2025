extends Node3D
class_name EnemySpawn

func _ready() -> void:
	add_to_group("enemy spawns")

func _exit_tree() -> void:
	remove_from_group("enemy spawns")
