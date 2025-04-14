@tool
extends BTAction

@export var target: StringName
@export var method: StringName
@export var arg: int #TODO: figure out how you can add multiple args from array

func _generate_name() -> String:
	return "call ${0}.{1}".format([Utils.bb_var(method), method])

func _tick(_delta: float) -> Status:
	blackboard.get_var(target).call_deferred(method, arg)
	return SUCCESS
