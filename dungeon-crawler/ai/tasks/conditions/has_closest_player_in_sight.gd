@tool
extends BTCondition

func _generate_name() -> String: return "can see a player"

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.closest_player_in_sight.is_some() else FAILURE
