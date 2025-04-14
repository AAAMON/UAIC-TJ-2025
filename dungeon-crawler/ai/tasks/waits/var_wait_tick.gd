@tool
extends BTWaitTicks

@export var actual_ticks: StringName

func _generate_name() -> String:
	return "WaitTicks x${0}".format([Utils.bb_var(actual_ticks)])

func _enter() -> void:
	num_ticks = blackboard.get_var(actual_ticks)
