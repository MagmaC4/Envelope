extends Node3D

@onready var handle := $Handle
@onready var audio := $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_rotation(view_pos: Vector3, delta: float) -> void:
	# To hell with all this math
	var view_dir = global_transform.affine_inverse() * view_pos
	view_dir = view_dir.normalized()
	var handle_dir = -handle.transform.basis.z.normalized()
	var angle_to = handle_dir.angle_to(view_dir)
	var signed_angle_to = handle_dir.signed_angle_to(view_dir, transform.basis.x.normalized())
	handle.rotate_x(signed_angle_to * delta * 5)
	print("=================================================")
	print("View Dir: " + str(view_dir))
	print("Crank Dir: " + str(handle_dir))
	print("Angle: " + str(angle_to))
	print("Signed Angle: " + str(signed_angle_to))

	# Play crank audio
	if not audio.playing:
		audio.play()
	
	# Stop cranking when player releases grab
	if Input.is_action_just_released("grab"):
		audio.stop()
		
		
