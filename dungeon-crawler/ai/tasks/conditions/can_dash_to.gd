@tool
extends BTCondition

@export var target: StringName

@export var max_angle := PI / 6

func _generate_name() -> String:
	return "can dash to ${0} in a straight line".format([Utils.bb_var(target)])

func _tick(_delta: float) -> Status: #TODO: implement ts
	var path := NavigationServer3D.map_get_path(
		agent.nav_agent.get_navigation_map(),
		blackboard.get_var(&"position_of_self"),
		blackboard.get_var(target),
		false
	)
	var to_angle := func(a: Vector3, b: Vector3, c: Vector3):
		return a.direction_to(b).angle_to(b.direction_to(c))
	var is_below_max_angle := func(angle: float): return angle < max_angle
	return SUCCESS if Utils.sliding_window(path, to_angle, 3).all(is_below_max_angle) else FAILURE
