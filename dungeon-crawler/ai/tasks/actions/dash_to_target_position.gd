@tool
extends BTAction

@export var speed := &"speed"

@export var dash_speed_modifier := 20

@export var dash_duration_in_ticks := 300

var elapsed_in_ticks := 0

func _generate_name() -> String: return "dash to target position with ${0} x {1} as a speed modifier for {2} ticks".format([Utils.bb_var(speed), dash_speed_modifier, dash_duration_in_ticks])

func _tick(_delta: float) -> Status:
	if elapsed_in_ticks == dash_duration_in_ticks:
		elapsed_in_ticks = 0
		return SUCCESS
	agent.velocity = (
		agent.global_position.direction_to(
			agent.nav_agent.target_position
		) * blackboard.get_var(speed) * dash_speed_modifier
	)
	agent.move_and_slide()
	elapsed_in_ticks += 1
	return RUNNING
