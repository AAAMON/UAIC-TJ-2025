extends StateWithBT

@export_range(1, 10, 1) var lookaround_max_count := 3
@export_range(2, 60, 1.0 / 60, "suffix:s") var lookaround_max_duration := 6.0
var lookaround_max_ticks:
	get(): return Engine.physics_ticks_per_second * lookaround_max_duration

var _lookaround: LookaroundData
var lookaround: LookaroundData:
	get(): return _lookaround

func _ready() -> void:
	_event_assoc_to = {
		$"../Aggro'd": "regained visual contact while searching",
		$"../Wandering": "wander after unproductive search"
	}
	success_event = event_assoc_to[$"../Aggro'd"]
	failure_event = event_assoc_to[$"../Wandering"]

func _enter() -> void:
	# VERY MUCH WIP
	var generate_lookaround := func():
		var count := randi_range(1, lookaround_max_count)
		var ticks := randi_range(1, max(1, lookaround_max_ticks / (count + 1)))
		_lookaround = LookaroundData.new(ticks)

		for i in range(count):
			var angle := randf_range(-PI, PI)
			var direction: Vector3 = Basis(agent.eyes.basis.y, angle) * agent.eyes.center_of_FOV # not sure about this
			_lookaround.append(ticks, direction.normalized())
	generate_lookaround.call()

	blackboard.set_var(&"initial_duration", lookaround.initial_duration)
	blackboard.set_var(&"array", lookaround.subseq)
	blackboard.bind_var_to_property(&"speed", agent.movement_speed, "wander", true)#TODO: make it so the sate machine controls these vars
