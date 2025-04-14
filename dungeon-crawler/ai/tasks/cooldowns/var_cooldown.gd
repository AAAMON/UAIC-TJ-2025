@tool
extends BTCooldown

@export var actual_duration: StringName

func _generate_name() -> String:
	return "Cooldown ${0} sec".format([Utils.bb_var(actual_duration)])

func _enter() -> void:
	duration = blackboard.get_var(actual_duration)
