# this condition is for a mock dash attack; if a dashing attack is to be implemented, rewrite this class
@tool
extends BTCondition

@export var target: StringName

func _generate_name() -> String:
	return "is in dashing range to ${0}".format([Utils.bb_var(target)])

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.global_position.distance_to(blackboard.get_var(target)) <= agent.melee_attack_range * 2 else FAILURE
