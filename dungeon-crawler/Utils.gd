extends Node
class_name Utils

static func random_pos_in_sphere(radius: float) -> Vector3:
	var direction := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var distance := pow(randf(), 1.0 / 3.0) * radius
	return direction * distance

static func min(arr: Array, transform: Callable):
	var min_until_now: Option = Option.None()
	for e in arr:
		if min_until_now.is_none() or transform.call(e) < transform.call(min_until_now.unwrap()):
			min_until_now = Option.Some(e)
	return min_until_now

static func max(arr: Array, transform: Callable):
	var max_until_now: Option = Option.None()
	for e in arr:
		if max_until_now.is_none() or transform.call(e) > transform.call(max_until_now.unwrap()):
			max_until_now = e
	return max_until_now

static func sliding_window(arr: Array, transform: Callable, size: int=2):
	var result := []
	for i in arr.size() - size + 1:
		result.append(transform.call(arr[i], arr[i + 1], arr[i + 2]))
	return result

static func identity(x): return x

static var _players: Array[Player]= []
static var players: Array[Player]:
	get: return _players

static func update_player_group(tree: SceneTree) -> void:
	_players.assign(tree.get_nodes_in_group("players"))

static func bb_var(n: StringName): return n if n else &"\"\""
