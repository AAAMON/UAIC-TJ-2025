extends Node3D
class_name Eyes

var _center_of_FOV := Vector3.FORWARD
var center_of_FOV := Vector3.FORWARD:
	get(): return _center_of_FOV
	set(value):
		_center_of_FOV = value
		global_transform.basis = Basis.looking_at(center_of_FOV)
var target_center_of_FOV := Vector3.FORWARD
var _fov: float = 5 * PI / 12
@export_range(0, 180, 1, "radians_as_degrees") var field_of_view:
	get(): return _fov
	set(value):
		_fov = value
		mesh_instance.mesh = fov_mesh()
@export_range(0, 1000, 1, "suffix:m", "exp") var detection_radius := 5.0
@export var sight_movement_speed := MovementSpeedData.new(2, 5)

@onready var mesh_instance := $MeshInstance3D

func fov_mesh() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)
	var circle_segments := 18
	var inner_segments := 8

	var point_at := func(fov_angle: float, circle_angle: float) -> Vector3:
		return Basis(
			Vector3.UP.rotated(Vector3.FORWARD, circle_angle),
			fov_angle
		) * Vector3.FORWARD * detection_radius
	for i in circle_segments:
		var angle := TAU * i / circle_segments

		var curr: Vector3 = point_at.call(field_of_view / 2, angle)

		st.add_vertex(Vector3.ZERO)
		st.add_vertex(curr)

		var last := curr
		for j in range(inner_segments - 1, 0, -1).map(func(jj): return jj as float / inner_segments):
			curr = point_at.call(field_of_view / 2 * j, angle)
			st.add_vertex(last)
			st.add_vertex(curr)
			last = curr

	var mesh := st.commit()
	var mat := StandardMaterial3D.new()
	mesh.surface_set_material(0, mat)
	return mesh

func _ready() -> void:
	mesh_instance.mesh = fov_mesh()

func _physics_process(delta: float) -> void:
	center_of_FOV = center_of_FOV.slerp(
		target_center_of_FOV,
		delta * (sight_movement_speed.wander if $"../State Machine".get_active_state() != $"../State Machine/Aggro'd" else sight_movement_speed.aggro) #TODO: make it so the sate machine controls these vars
	)
