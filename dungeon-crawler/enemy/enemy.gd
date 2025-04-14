extends CharacterBody3D
class_name Enemy

@onready var nav_agent := $NavigationAgent3D
@onready var eyes := $Eyes
@onready var state_machine := $"State Machine"

@export var wandering_max_radius := 10.0

@export var max_hp := 100
var hp := max_hp
@export var damage := 10
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var melee_cooldown_duration := 2.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var melee_attack_range := 2.0
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var duration_of_pause_after_melee_attack := 2.0

@export var movement_speed := MovementSpeedData.new(2, 3)
@export var aggro_path_recalculation_cooldown_duration := 0.33

func _ready():
	if NavigationServer3D.get_maps().size() == 0:
		await NavigationServer3D.map_changed
	add_to_group("enemies")
	state_machine.set_active(true)

func _exit_tree() -> void:
	remove_from_group("enemies")

func can_see(p: Player) -> bool:
	return (
		global_position.distance_to(p.global_position) <= eyes.detection_radius
			and
		eyes.center_of_FOV.angle_to(
			global_position.direction_to(p.global_position)
		) <= eyes.field_of_view / 2
	)

var _closest_player_in_sight: Option = Option.None()
var closest_player_in_sight: Option:
	get(): return _closest_player_in_sight
var closest_player_in_sight_unwrapped: Player:
	get(): return closest_player_in_sight.unwrap()
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
		print("enemy died :(")
		queue_free()
		return
	var seen := Utils.players.filter(can_see)
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.albedo_color = Color(0, 0, 1) if seen.size() > 0 else Color(0, 1, 0)
	eyes.mesh_instance.set_surface_override_material(0, material)

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
