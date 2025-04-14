extends StateWithBT

func _ready() -> void:
	_event_assoc_to = {
		$"../Going where player was last seen": "lost visual contact"
	}
	failure_event = event_assoc_to[$"../Going where player was last seen"]

func _enter() -> void:
	#print("aggro")
	blackboard.bind_var_to_property(
		"closest_player_in_sight", agent, &"closest_player_in_sight", true
	)
	blackboard.bind_var_to_property(
		"position_of_closest_player_in_sight", agent,
		&"position_of_closest_player_in_sight", true
	)
	blackboard.bind_var_to_property(
		"melee_cooldown_duration", agent,
		&"melee_cooldown_duration", true
	)
	blackboard.bind_var_to_property(
		"aggro_path_recalculation_cooldown_duration", agent,
		&"aggro_path_recalculation_cooldown_duration", true
	)
	blackboard.bind_var_to_property("speed", agent.movement_speed, &"aggro", true)#TODO: make it so the sate machine controls these vars
	blackboard.bind_var_to_property("position_of_self", agent, &"global_position", true)
