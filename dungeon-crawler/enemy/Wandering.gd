extends IBehaviour
class_name Wandering

func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % enemy.aggro_tick_interval == 0:
		enemy.target = enemy.attempt_to_aggro_on_a_player()
		if enemy.target.is_some(): enemy.behaviour = Chasing.new(enemy)
