extends CharacterBody3D

@export var player_path := "/root/TestWorld/Player"

@onready var nav_agent = $NavigationAgent3D

const SPEED = 1.0

var player = null
var aggro = false

# Random movelemt
var random_target: Vector3 = Vector3.ZERO
var random_move_time = 0.0
var random_move_interval = 3.0 # Time interval between random movements
var random_move_radius = 10.0 # Radius for random movement

var gravity = -9.8 # Gravity constant (adjust as needed)
	

func _ready() -> void:
	player = get_node(player_path)
	velocity = Vector3.ZERO

func __apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func _physics_process(delta: float) -> void:
	__apply_gravity(delta)
	
	# Calculate the distance between the enemy and the player
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	if distance_to_player <= 7.0:
		aggro = true
	if distance_to_player > 15.0:
		aggro = false
	
	if aggro == true:
		# Navigation
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		
		# Look at player
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	else:
		# move randomly hggh
		random_move_time -= delta
		
		if random_move_time <= 0.0:
			# Choose a random target position within the radius
			random_target = global_transform.origin + Vector3(
				randf_range(-random_move_radius, random_move_radius),
				player.global_transform.origin.y,
				randf_range(-random_move_radius, random_move_radius)
			)
			random_move_time = random_move_interval # Reset the random movement timer
		
		# Move towards the random target
		nav_agent.set_target_position(random_target)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		
		# Optionally, look in the direction of the random target
		look_at(Vector3(random_target.x, global_position.y, random_target.z), Vector3.UP)
	
	move_and_slide()
