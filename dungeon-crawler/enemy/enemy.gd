extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D
@onready var timer := $Timer

@export var max_radius := 10.0
@export var movement_speed := 5.0

@export var allowed_destination_error := 0.5

var intended_velocity: Vector3
var time_stuck: float
@export var time_stuck_limit := 1

func _ready():
	pick_random_destination()
	intended_velocity = Vector3.ZERO
	time_stuck = 0.0

func _physics_process(delta: float) -> void:
	var destination_relative: Vector3 = nav_agent.get_next_path_position() - global_position
	var direction = destination_relative.normalized()

	if global_position.distance_to(nav_agent.target_position) > allowed_destination_error:
		velocity = direction * movement_speed
	else:
		velocity = Vector3.ZERO
	intended_velocity = velocity
	move_and_slide()
	check_if_stuck(delta)
	## pitiful attempt at making enemies push characters, this needs more thinking
	#for i in get_slide_collision_count():
		#var collision := get_slide_collision(i)
		#var collider := collision.get_collider()
		#var normal := collision.get_normal()
		#
		#if collider is CharacterBody3D:
			#push_character(collider, normal)

### very much WIP
func check_if_stuck(delta):
	if velocity.length() < intended_velocity.length():
		time_stuck += delta
		if time_stuck > time_stuck_limit:
			print("NPC stuck! Recalculating path...")
			nav_agent.target_position = nav_agent.target_position
			time_stuck = 0.0
	else:
		time_stuck = 0.0

func pick_random_destination():
	#print("started picking")
	var nav_map: RID = nav_agent.get_navigation_map()
	var origin := global_position
	var random_point := origin + Utils.random_pos_in_sphere(max_radius)
	nav_agent.target_position = NavigationServer3D.map_get_closest_point(nav_map, random_point)


func push_character(obj: CharacterBody3D, normal: Vector3):
	obj.velocity += normal * 10
	obj.move_and_slide()


func _on_navigation_agent_3d_navigation_finished() -> void:
	timer.start(randf_range(0, 2))
	await timer.timeout
	pick_random_destination()
