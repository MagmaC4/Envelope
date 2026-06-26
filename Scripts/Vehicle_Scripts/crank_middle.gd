extends Node3D

# Children
@onready var handle := $Handle
@onready var audio := $AudioStreamPlayer3D

# Generate power when cranking, adding power depends on direction
const MAX_POWER := 100.0
const POWER_ADD := 20
const POWER_SUB := 5
var power := 0.0


# Rotating after letting go
const TWEEN_TIME := 0.5
var floaty_rotation := 0.0

# Miscellaneous
var print_timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.play()
	audio.volume_db = -100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Decrease power 
	subtract_power(delta * POWER_SUB)
	handle_floaty_rotation(delta)
	

func handle_rotation(view_pos: Vector3, delta: float) -> void:
	# To hell with all this math
	var view_dir = global_transform.affine_inverse() * view_pos
	view_dir = view_dir.normalized()
	var handle_dir = -handle.transform.basis.z.normalized()
	var angle_to = handle_dir.angle_to(view_dir)
	var axis = -transform.basis.z.normalized() # dis is jank but works
	var signed_angle_to = handle_dir.signed_angle_to(view_dir, axis)
	handle.rotate_x(signed_angle_to * delta * 5)
	
	# Add power based on rotation amount
	add_power(abs(signed_angle_to) * POWER_ADD * delta)

	# Increase volume and pitch of crank audio based on magnitude of angle
	var volume = lerp(-40, 0, abs(signed_angle_to) / (PI / 2))
	audio.volume_db = clamp(volume, -40, 0)
	var pitch = lerp(0.5, 2.0, abs(signed_angle_to) / (PI / 2))
	audio.pitch_scale = clamp(pitch, 0.5, 1.5)
	
	# Debug prints
	# print_timer += delta
	if (print_timer >= 1.0):
		print_timer = 0.0
		print("=================================================")
		print("CRANK INFORMATION")
		print("View Dir: " + str(view_dir))
		print("Crank Dir: " + str(handle_dir))
		print("Angle: " + str(angle_to))
		print("Signed Angle: " + str(signed_angle_to))
		print("Power: " + str(power))
		print("Audio Volume db: " + str(audio.volume_db))
		print("Audio Pitch: " + str(audio.pitch_scale))
	
	
	# Reset crank when no longer grabbing
	if Input.is_action_just_released("grab"):
		# Set audio to 0 (smoothly)
		var audio_tween = create_tween()
		audio_tween.tween_property(audio, "volume_db", -100, TWEEN_TIME)
		
		# Keep crank rotating briefly after letting go
		floaty_rotation = signed_angle_to
		var rotation_tween = create_tween()
		rotation_tween.tween_property(self, "floaty_rotation", 0, TWEEN_TIME)
		
# residual rotation after letting go of the handle
func handle_floaty_rotation(delta):
	handle.rotate_x(floaty_rotation * delta * 5)
	
# ignore this blame ben
func handle_grab():
	pass
	
		
func add_power(num : float):
	power += num
	if power > MAX_POWER:
		power = MAX_POWER
	
func subtract_power(num : float):
	power -= num
	if power < 0:
		power = 0
