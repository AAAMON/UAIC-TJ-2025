@tool
extends BTCondition

@export var target: StringName

func _generate_name() -> String:
	return "is in melee range to ${0}".format([Utils.bb_var(target)])

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.global_position.distance_to(blackboard.get_var(target)) <= (agent as Enemy).melee_attack_range_with_nav_agent_radius else FAILURE
