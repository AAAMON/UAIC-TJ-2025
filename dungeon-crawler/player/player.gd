extends CharacterBody3D

const MOVEMENT_SPEED = 3.0
const JUMP_VELOCITY = 4.5
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
const ACCELERATION = 10.0
const DECELERATION = 15.0

@onready var camera = $Camera

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# move view with mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -(PI/2), (PI/3))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func __apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

func _physics_process(delta: float) -> void:
	__apply_gravity(delta)
	
	# jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# move
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0,  input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * MOVEMENT_SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)
	move_and_slide()
