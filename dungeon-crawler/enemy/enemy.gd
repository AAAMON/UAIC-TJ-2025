extends CharacterBody3D
class_name Enemy

@onready var nav_agent := $NavigationAgent3D
@onready var timer := $Timer

@export var max_radius := 10.0
@export var movement_speed := 3

var curr_target := Vector3.ZERO

func _ready():
	await NavigationServer3D.map_changed
	pick_random_destination()

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished(): return
	if global_position.distance_to(curr_target) < nav_agent.path_desired_distance:
		curr_target = nav_agent.get_next_path_position()
	var direction := global_position.direction_to(curr_target)
	nav_agent.velocity = direction * movement_speed

func pick_random_destination():
	var nav_map: RID = nav_agent.get_navigation_map()
	var origin := global_position
	var random_point := origin + Utils.random_pos_in_sphere(max_radius)
	nav_agent.target_position = NavigationServer3D.map_get_closest_point(nav_map, random_point)
	curr_target = nav_agent.get_next_path_position()


func _on_navigation_agent_3d_navigation_finished() -> void:
	timer.start(randf_range(0, 2))
	await timer.timeout
	pick_random_destination()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
