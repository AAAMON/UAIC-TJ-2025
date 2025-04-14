@tool
extends BTAction

@export var from: StringName
@export var duration := &"duration"
@export var direction := &"direction"

func _generate_name() -> String:
	return "split ${0} into ${1} and ${2}".format(
		[Utils.bb_var(from), Utils.bb_var(duration), Utils.bb_var(direction)]
	)

func _tick(_delta: float) -> Status:
	var from_v = blackboard.get_var(from)
	blackboard.set_var(duration, from_v.duration)
	blackboard.set_var(direction, from_v.direction)
	return SUCCESS
