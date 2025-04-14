@tool
extends BTAction

@export var target: StringName

func _generate_name() -> String:
	return "look towards ${0}".format([Utils.bb_var(target)])

func _tick(_delta: float) -> Status:
	agent.eyes.target_center_of_FOV = agent.global_position.direction_to(
		blackboard.get_var(target)
	)
	return SUCCESS
