@tool
extends BTAction

@export var speed := &"speed"

func _generate_name() -> String:
	return "navigate to target position and look ahead of the track with ${0} as a speed modifier".format([Utils.bb_var(speed)])

func _tick(_delta: float) -> Status:
	if agent.nav_agent.is_navigation_finished():
		return SUCCESS
	agent.eyes.target_center_of_FOV = agent.global_position.direction_to(
		agent.nav_agent.get_next_path_position()
	)
	agent.nav_agent.velocity = (
		agent.eyes.target_center_of_FOV * blackboard.get_var(speed)
	)
	return RUNNING
