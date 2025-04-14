extends StateWithBT

func _ready() -> void:
	_event_assoc_to = {
		$"../Aggro'd": "regained visual contact before search",
		$"../Searching": "searching after losing visual contact"
	}
	success_event = event_assoc_to[$"../Aggro'd"]
	failure_event = event_assoc_to[$"../Searching"]

func _enter() -> void:
	#print("searching")
	blackboard.bind_var_to_property(&"speed", agent.movement_speed, "aggro", true)#TODO: make it so the sate machine controls these vars
	agent.nav_agent.target_position = agent.position_of_closest_player_in_sight
