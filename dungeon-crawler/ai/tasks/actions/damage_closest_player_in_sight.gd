@tool
extends BTAction

@export var damage_amount := 1

func _generate_name() -> String:
	return "deal {0} damage to the closest player in sight".format([damage_amount])

func _tick(_delta: float) -> Status:
	agent.closest_player_in_sight.unwrap().take_damage(damage_amount)
	return SUCCESS
