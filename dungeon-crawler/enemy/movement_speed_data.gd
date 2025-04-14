extends Resource
class_name MovementSpeedData

@export var wander: float
@export var aggro: float

func _init(wander_: float, aggro_: float) -> void:
	wander = wander_
	aggro = aggro_
