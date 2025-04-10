extends CharacterBody3D
@onready var camera = $Camera
@onready var anim_player = $AnimationPlayer
@onready var dagger_hitbox = $Camera/HandPivot/Hand/Dagger/DaggerHitbox

# MOVEMENT #####################################################################
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const MOVEMENT_SPEED = 3.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 10.0
const DECELERATION = 15.0
# ATTACK #######################################################################
var is_attacking = false

var hp: int = global.hp
var max_hp: int = global.max_hp

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# move view with mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -(PI/2), (PI/3))


# Input alea alea ##############################################################
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("primary_attack"):
		anim_player.play("PrimaryAttack")
		dagger_hitbox.monitoring = true
	

func __apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "PrimaryAttack":
		anim_player.play("Idle")
		dagger_hitbox.monitoring = false


func _on_dagger_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		print("Hit something!")
		
func take_damage(amount: int) -> void:
	hp = max(hp - amount, 0) 
	if hp == 0:
		die() 

func heal(amount: int) -> void:
	hp = min(hp + amount, max_hp)  

func die() -> void:
	print("Player has died.")
	queue_free()  
