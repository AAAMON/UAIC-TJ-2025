extends CharacterBody3D
class_name Player

@onready var camera = $Camera
@onready var anim_player = $AnimationPlayer
@onready var dagger_hitbox = $Camera/HandPivot/Hand/Dagger/DaggerHitbox
@onready var sword_hitbox = $Camera/HandPivot/HandTwo1/sword_1/SwordHitbox
@onready var hand1 = $Camera/HandPivot/Hand
@onready var hand2 = $Camera/HandPivot/HandTwo1
@onready var inventory_ui = $InventoryUI
@onready var crafting_ui = $CraftUI
@onready var game_log = $LogUI/RichTextLabel


const MAX_HP = 50
const MOVEMENT_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 15.0
const DECELERATION = 15.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_attack = false
var hp
var weapon = 1



func _ready() -> void:
	add_to_group("players")
	Utils.update_player_group(get_tree())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hp = MAX_HP
	global.set_player_reference(self)

func _exit_tree() -> void:
	remove_from_group("players")
	Utils.update_player_group(get_tree())

# move view with mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and captured:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -(PI/2), (PI/3))

var captured := true
# Input alea alea ##############################################################
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if Input.is_action_just_pressed("capture_or_release_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if captured else Input.MOUSE_MODE_CAPTURED)
		captured = not captured
	
	if Input.is_action_just_pressed("Weapon1"):
		weapon = 1
		hand1.show()
		hand2.hide()
		
	if Input.is_action_just_pressed("Weapon2"):
		weapon = 2
		hand2.show()
		hand1.hide()

	if Input.is_action_just_pressed("primary_attack"):
		if weapon == 1:
			anim_player.play("PrimaryAttack")
		else:
			anim_player.play("PrimaryAttack2")
		dagger_hitbox.monitoring = true
	if Input.is_action_just_pressed("secondary_attack"):
		if weapon == 1:
			anim_player.play("SecondaryAttack")
		else:
			anim_player.play("SecondaryAttack2")
		dagger_hitbox.monitoring = true
	if Input.is_action_just_pressed("tertiary_attack"):
		if weapon == 1:
			anim_player.play("TertiaryAttack")
		else:
			anim_player.play("TertiaryAttack2")
		dagger_hitbox.monitoring = true
		
	if Input.is_action_just_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		if inventory_ui.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = !get_tree().paused
	
	if Input.is_action_just_pressed("crafting"):
		crafting_ui.visible = !crafting_ui.visible
		if crafting_ui.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = !get_tree().paused


func _physics_process(delta: float) -> void:
	velocity.y += Utils.gravity_horizontal_modification(self, delta)
	
	# jump
	if Input.is_action_just_pressed("ui_accept"):# and is_on_floor():
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
	if anim_name == "PrimaryAttack" or anim_name == "SecondaryAttack" or anim_name == "TertiaryAttack":
		anim_player.play("Idle")
		dagger_hitbox.monitoring = false
	if anim_name == "PrimaryAttack2" or anim_name == "SecondaryAttack2" or anim_name == "TertiaryAttack2":
		anim_player.play("Idle2")
		dagger_hitbox.monitoring = false
	can_attack = true


func _on_dagger_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies") and can_attack == true:
		can_attack = false 
		# change this so smth calculated
		body.take_damage(2)
		
func take_damage(amount: int) -> void:
	var strr = "You took " + str(amount) + " damage!"
	print(strr)
	game_log.add_log_line(strr)
	hp = hp - amount
	if hp <= 0:
		die() 

#func heal(amount: int) -> void:
	#hp = min(hp + amount, max_hp)  

func die() -> void:
	print("Player has died.")
	#queue_free()  


func _on_sword_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies") and can_attack == true:
		can_attack = false 
		# change this so smth calculated
		body.take_damage(5)

func _on_Item_picked_up(item_data):
	global.add_item(item_data)
	game_log.add_log_line("You took ", item_data.name, " damage!")
