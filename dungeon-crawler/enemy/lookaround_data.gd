extends Resource
class_name LookaroundData

class LookaroundDataPiece:
	var duration: int
	var direction: Vector3
	
	func _init(duration_: int, direction_: Vector3):
		duration = duration_
		direction = direction_

var initial_duration: int
var subseq: Array[LookaroundDataPiece]

func _init(initial_duration_: int) -> void:
	initial_duration = initial_duration_

func append(duration: int, direction: Vector3):
	subseq.append(LookaroundDataPiece.new(duration, direction))
