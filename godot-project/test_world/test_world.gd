extends Node3D

@export var player_scn: PackedScene

@onready var player_spawn_point = $PlayerSpawnPoint
@onready var enemy_spawns = $World/Spawns
@onready var navigation_reg = $World/NavigationRegion3D

var enemy_1 = load("res://enemy/enemy_1/enemy_1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	randomize()
	# Create and add player
	#var player = player_scn.instantiate()
	#player.position = player_spawn_point.position
	#add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)


func _on_e_1_timeout() -> void:
	var spawn_point = _get_random_child(enemy_spawns).global_position
	var instance = enemy_1.instantiate()
	instance.position = spawn_point
	navigation_reg.add_child(instance)
