extends CharacterBody3D
class_name Enemy

@onready var nav_agent := $NavigationAgent3D
@onready var timer := $Timer
@onready var eyes := $Eyes

@export var wandering_max_radius := 10.0

@export var max_hp := 100
var hp := max_hp
@export var damage := 10

@export var movement_speed_when_not_aggro := 3
@export_range(1, 10, 1) var lookaround_max_count := 3
var tps: int = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
var lookaround_max_duration_in_ticks := 3 * tps
@export_range(2, 60, 1.0 / 60, "suffix:s") var lookaround_max_duration: float: #1 / 60 is a workaround for 1 / tps
	get(): return lookaround_max_duration_in_ticks / tps
	set(value): lookaround_max_duration_in_ticks = int(value * tps)
	
var lookaround := {"directions": [], "durations": []}
enum lookaround_state_enum {pre, main, post}
var lookaround_state := lookaround_state_enum.pre

var curr_target := Vector3.ZERO

@export var aggro_tick_interval := 10
var behaviour: IBehaviour = Wandering.new(self)
var target := Option.None()

func _ready():
	await NavigationServer3D.map_changed
	pick_random_destination()

func can_see(p: Player) -> bool:
	return (
		global_position.distance_to(p.global_position) <= eyes.detection_radius
			and
		eyes.center_of_FOV.angle_to(
			global_position.direction_to(p.global_position)
		) <= eyes.field_of_view / 2
	)

# this is tested with only one player
# if, in the future, there are more players (allies, decoys etc.)
# test again / change what needs to be changed
func attempt_to_aggro_on_a_player() -> Option:
	# filters the players into 
	var seen := Utils.players.filter(can_see)
	return Utils.min(seen, func(e: Player): return global_position.distance_to(e.global_position))

func _process(_delta: float) -> void:
	var seen := Utils.players.filter(can_see)
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.albedo_color = Color(0, 0, 1) if seen.size() > 0 else Color(0, 1, 0)
	eyes.mesh_instance.set_surface_override_material(0, material)

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		match lookaround_state:
			lookaround_state_enum.pre: pass
			lookaround_state_enum.main:
				if lookaround["durations"][0] == 0:
					lookaround["durations"].remove_at(0)
					if lookaround["directions"].size() > 0:
						lookaround["directions"].remove_at(0)
				if lookaround["durations"].size() == 0:
					lookaround_state = lookaround_state_enum.post
				else:
					lookaround["durations"][0] -= 1
					if lookaround["directions"].size() > 0:
						eyes.target_center_of_FOV = lookaround["directions"][0]
				#print(str(self) + ": {durations}, {directions}".format(lookaround))
			lookaround_state_enum.post:
				lookaround_state = lookaround_state_enum.pre
				pick_random_destination()
		return
	curr_target = nav_agent.get_next_path_position()
	eyes.target_center_of_FOV = global_position.direction_to(curr_target).normalized()
	nav_agent.velocity = eyes.target_center_of_FOV * movement_speed_when_not_aggro

# VERY MUCH WIP
func prepare_lookaround() -> void:
	var count := randi_range(1, lookaround_max_count)
	var ticks := randi_range(1, max(1, lookaround_max_duration_in_ticks / (count + 1)))

	lookaround["durations"].append(ticks)
	for i in range(count):
		var angle := randf_range(-PI, PI)
		var direction: Vector3 = Basis((eyes.basis as Basis).y, angle) * eyes.center_of_FOV
		lookaround["directions"].append(direction.normalized())
		lookaround["durations"].append(ticks)

	lookaround_state = lookaround_state_enum.main

func pick_random_destination():
	var nav_map: RID = nav_agent.get_navigation_map()
	var origin := global_position
	var random_point := origin + Utils.random_pos_in_sphere(wandering_max_radius)
	nav_agent.target_position = NavigationServer3D.map_get_closest_point(nav_map, random_point)


func _on_navigation_agent_3d_navigation_finished() -> void:
	prepare_lookaround()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_hitbox_area_entered(area: Area3D) -> void:
	hp -= 5
	#print("lol")
