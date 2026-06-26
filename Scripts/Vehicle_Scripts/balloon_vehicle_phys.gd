extends AnimatableBody3D

# Nodes
@onready var left_crank: Node3D = $Crank
@onready var right_crank: Node3D = $Crank2
@onready var rope: Node3D = $Rope
@onready var burner: Node3D = $Burner
@onready var altimeter = $Altimeter
@onready var thermometer = $Thermometer

# Movement
var BASELINE_GRAVITY = -1 # temp var for embark/disembark
var GRAVITY = BASELINE_GRAVITY
const DRAG = 0.5
const MAX_BUOYANCY = 6.0
const MAX_Y_VELOCITY = 3
var velocity : Vector3 = Vector3.ZERO

const SPEED_MULT = 0.1
const MAX_PITCH = 15
const MAX_ROLL = 30
var print_time : float = 0

func _ready():
	# prioritize balloon physics over player
	# this ensures raycasts get correct world information
	process_priority = -1
	
	
func _physics_process(delta: float) -> void:
	# Move vehicle based on cranks + burner power
	handle_movement(delta)
	# Align rope with world
	rope.global_rotation = Vector3.ZERO
	# Set altimeter gauge's value with height
	altimeter.value = global_position.y
	# Set thermometer gauge's value with burner power
	thermometer.value = burner.power
	
# ==============================================================================
# Movement
func handle_movement(delta : float) -> void:
	# Vertical movement based on burner power
	var buoyancy = (burner.power / 100) * MAX_BUOYANCY
	velocity.y += (GRAVITY + buoyancy) * delta
	velocity.y -= velocity.y * DRAG * delta # simulate drag
	
	# Cap upwards velocity
	if velocity.y > MAX_Y_VELOCITY:
		velocity.y = MAX_Y_VELOCITY
		
	# Move vehicle in Forward direction based on crank power
	var power_total = right_crank.power + left_crank.power
	var forward = -basis.z
	forward.y = 0
	forward = forward.normalized()
	velocity.x = forward.x * power_total * SPEED_MULT
	velocity.z = forward.z * power_total * SPEED_MULT
	
	if move_and_collide(velocity * delta):
		# If a collision is detected, stop falling down
		# This assumes the collision is below the hot air balloon
		if velocity.y < 0:
			velocity.y = 0
	
	
	
	# Simulated sway on x and z axis
	var t = Time.get_ticks_msec() * 0.001
	var sway_x = sin(t) * 3.0
	var sway_z = sin(t * 0.7 + 1.2) * 2.0
	# Don't sway when not moving
	if (abs(velocity.y) <= 0.1):
		sway_x = 0
		sway_z = 0
	
	# Rotate vehicle (x: pitch) based on forward speed
	var pitch = clamp(power_total / 200 * MAX_PITCH, -MAX_PITCH, MAX_PITCH)
	rotation_degrees.x = lerp(rotation_degrees.x, pitch + sway_x, delta * 3)
	# Rotate vehicle (y: yaw) based on crank power
	var power_diff  = right_crank.power - left_crank.power
	var yaw = rotation_degrees.y + power_diff * 0.5
	rotation_degrees.y = lerp(rotation_degrees.y, yaw, delta * 0.5)
	# rotation_degrees.y += power_diff * 0.5 * delta 
	# Rotate vehicle (z: roll) based on rotation speed
	var roll = clamp(power_diff / 100 * MAX_ROLL, -MAX_ROLL, MAX_ROLL)
	rotation_degrees.z = lerp(rotation_degrees.z, roll + sway_z, delta * 3)
	
	# Debug info prints
	print_time += delta 
	if print_time / 1.0 > 0.5:
		print_time = 0
		print("=================================================")
		print("Physics Ballon Debug Information")
		print("Power Total: " + str(power_total))
		print("Power Difference: " + str(power_diff))
		print("Velocity: " + str(velocity))
		print("Rotation: " + str(rotation))
	
# ==============================================================================
# Vehicle Embark / Disembark

func _on_cabin_trigger_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerTwin"):
		print("Vehicle entered")
		var vehicle_node = self
		reparent_player(area, vehicle_node)
		GRAVITY = BASELINE_GRAVITY
		
func _on_cabin_trigger_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerTwin"):
		print("Vehicle exited")
		var world_node = get_tree().current_scene
		reparent_player(area, world_node)
		GRAVITY = BASELINE_GRAVITY * 3
		 
func reparent_player(area: Area3D, parent: Node3D):
# Turn off Area3D monitoring so when scene tree changes,
# the player doesn't send an Area Exited signal
	var player = area.player
	player.reparent(parent, true)
	
	# Smoothly reset local rotation to zero
	var tween = create_tween().set_parallel(true)
	tween.tween_property(player,"rotation:z", 0, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(player,"rotation:x", 0, 0.5).set_trans(Tween.TRANS_SINE)
