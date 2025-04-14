@tool
extends BTWait

@export var actual_duration: StringName

func _generate_name() -> String:
	return "Wait ${0} sec".format([Utils.bb_var(actual_duration)])

func _enter() -> void:
	duration = blackboard.get_var(actual_duration)
