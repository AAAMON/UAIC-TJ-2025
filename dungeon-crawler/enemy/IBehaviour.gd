extends RefCounted
class_name IBehaviour

var enemy: Enemy

func _init(e: Enemy) -> void:
	enemy = e

func _physics_process(delta: float) -> void: pass
