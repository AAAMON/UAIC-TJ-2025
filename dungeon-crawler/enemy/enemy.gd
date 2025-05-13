extends CharacterBody3D
class_name Enemy

@onready var nav_agent := $NavigationAgent3D
@onready var eyes := $Eyes
@onready var state_machine := $"State Machine"

@export_custom(PROPERTY_HINT_NONE, "suffix:m") var wandering_max_radius := 10.0
const ENEMY_1_DROP = preload("res://items/item_varations/item_enemy_1.tscn")
const ENEMY_2_DROP = preload("res://items/item_varations/item_enemy_2.tscn")


@export var max_hp := 10
var hp := max_hp
@export var damage := 10
var _melee_cooldown_duration_after_pause := 2.0
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var melee_cooldown_duration: float:
	get(): return _melee_cooldown_duration_after_pause + duration_of_pause_after_melee_attack
	set(value):
		_melee_cooldown_duration_after_pause = clampf(value - duration_of_pause_after_melee_attack, 0, 9999)
var _duration_of_pause_after_melee_attack := 2.0
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var duration_of_pause_after_melee_attack: float:
	get(): return _duration_of_pause_after_melee_attack
	set(value):
		_duration_of_pause_after_melee_attack = value
		melee_cooldown_duration = melee_cooldown_duration

@export_custom(PROPERTY_HINT_NONE, "suffix:m") var melee_attack_range := 2.0
var melee_attack_range_with_nav_agent_radius: float:
	get(): return melee_attack_range + nav_agent.radius

@export var movement_speed := MovementSpeedData.new(2, 3)
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var aggro_path_recalculation_cooldown_duration := 0.33

@export var drop_item: PackedScene


func _ready():
	if NavigationServer3D.get_maps().size() == 0:
		await NavigationServer3D.map_changed
	add_to_group("enemies")
	state_machine.set_active(true)
	if name.to_lower().contains("enemy"):
		drop_item = ENEMY_1_DROP
	elif name.to_lower().contains("CharacterBody3D"):
		drop_item = ENEMY_2_DROP
	print("READY - enemy name:", name)

func _exit_tree() -> void:
	remove_from_group("enemies")

func can_see(p: Player) -> bool:
	return (
		eyes.global_position.distance_to(p.global_position) <= eyes.detection_radius
			and
		eyes.center_of_FOV.angle_to(
			global_position.direction_to(p.global_position)
		) <= eyes.field_of_view / 2
	)

var _closest_player_in_sight: Option = Option.None()
var closest_player_in_sight: Option:
	get(): return _closest_player_in_sight
var _position_of_closest_player_in_sight: Vector3
var position_of_closest_player_in_sight: Vector3:
	get(): return _position_of_closest_player_in_sight

# this is tested with only one player
# if, in the future, there are more players (allies, decoys etc.)
# test again / change what needs to be changed
func update_closest_player_in_sight() -> void:
	# filters the players into 
	var seen := Utils.players.filter(can_see)
	_closest_player_in_sight = Utils.min(seen, func(e: Player): return global_position.distance_to(e.global_position))
	if closest_player_in_sight.is_some():
		_position_of_closest_player_in_sight = closest_player_in_sight.unwrap().global_position

func _process(_delta: float) -> void:
	if hp <= 0:
		print("enemy died :)")
		die()
		return
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.albedo_color = Color(0, 0, 1) if closest_player_in_sight.is_some() else Color(0, 1, 0)
	eyes.mesh_instance.set_surface_override_material(0, material)
	
func die():
	if drop_item:
		var dropped = drop_item.instantiate()
		dropped.global_position = global_position
		get_parent().add_child(dropped)
	queue_free()

var _last_physics_process_delta: float
var last_physics_process_delta: float:
	get(): return _last_physics_process_delta
func _physics_process(delta: float) -> void:
	update_closest_player_in_sight()
	_last_physics_process_delta = delta

func pick_random_destination():
	var nav_map: RID = nav_agent.get_navigation_map()
	var origin := global_position
	var random_point := origin + Utils.random_pos_in_sphere(wandering_max_radius)
	nav_agent.target_position = NavigationServer3D.map_get_closest_point(nav_map, random_point)

func __apply_gravity():
	if not is_on_floor():
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * last_physics_process_delta

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	velocity.y += Utils.gravity_horizontal_modification(self, last_physics_process_delta)
	move_and_slide()


func take_damage(value: int):
	hp = hp - value
	print("Enemy took ", value, " damage!")
