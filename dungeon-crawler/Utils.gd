extends Node

class_name Utils

static func random_pos_in_sphere(radius: float) -> Vector3:
	var direction := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var distance := pow(randf(), 1.0 / 3.0) * radius
	return direction * distance
