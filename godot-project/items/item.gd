extends Area3D

@export var item_id: String
@export var time_until_despawn: float = 30.0

@onready var despawn_timer: Timer = $Timer

func _ready():
	despawn_timer.wait_time = time_until_despawn
	despawn_timer.one_shot = true
	despawn_timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		global.add_to_inventory(item_id)
		queue_free()

func _on_Timer_timeout():
	queue_free()
