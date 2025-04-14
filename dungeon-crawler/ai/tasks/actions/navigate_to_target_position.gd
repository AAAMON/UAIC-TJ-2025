@tool
extends BTAction

@export var speed := &"speed"

func _generate_name() -> String: return "navigate to target position with ${0} as a speed modifier".format([Utils.bb_var(speed)])

func _tick(_delta: float) -> Status:
	if not agent.nav_agent.is_navigation_finished():
		agent.nav_agent.velocity = (
			agent.global_position.direction_to(
				agent.nav_agent.get_next_path_position()
			) * blackboard.get_var(speed)
		)
	return SUCCESS
