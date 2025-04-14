extends StateWithBT

func _ready() -> void:
	_event_assoc_to = {
		$"../Aggro'd": "target aquired",
		$"../Searching": "search after wander"
	}
	success_event = event_assoc_to[$"../Aggro'd"]
	failure_event = event_assoc_to[$"../Searching"]

func _enter() -> void:
	blackboard.bind_var_to_property(&"speed", agent.movement_speed, "wander", true)#TODO: make it so the sate machine controls these vars
	agent.pick_random_destination()
