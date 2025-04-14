@tool
extends BTAction

@export var target: StringName

func _generate_name() -> String:
	return "set navigation target position to ${0}".format([Utils.bb_var(target)])

func _tick(_delta: float) -> Status:
	agent.nav_agent.target_position = blackboard.get_var(target)
	return SUCCESS
