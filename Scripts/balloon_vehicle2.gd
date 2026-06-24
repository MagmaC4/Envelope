extends AnimatableBody3D

# Nodes
@onready var left_crank: Node3D = $Crank
@onready var right_crank: Node3D = $Crank2
@onready var rope: Node3D = $Rope
@onready var altimeter = $Altimeter
@onready var thermometer = $Thermometer

# Movement
var GRAVITY = 4
var MAX_FALL = -5
var MAX_RISE = 10
var velocity : Vector3 = Vector3.ZERO
var rotation_resistance := 1.0
var rot_vel : float = 0.0
var print_time : float = 0
	
func _physics_process(delta: float) -> void:
	# Move vehicle based on cranks + burner power
	handle_movement(delta)
	# Align rope with world
	rope.global_rotation = Vector3.ZERO
	# Set altimeter gauge's value with height
	altimeter.value = global_position.y
	# Set thermometer gauge's value with burner power
	thermometer.value = rope.power
	
# ==============================================================================
# Movement
func handle_movement(delta : float) -> void:
	velocity.y += (rope.power - GRAVITY) * .05 * delta
	velocity.y = clamp(velocity.y, MAX_FALL, MAX_RISE)
	
	if move_and_collide(delta * velocity):
		# If a collision is detected, stop falling down
		# This assumes the collision is below the hot air balloon
		velocity.y = clamp(velocity.y, 0, MAX_RISE)
	
	var speed = (left_crank.power + right_crank.power) * delta
	speed = clamp(speed, 0, 20)
	# Move vehicle in Forward direction
	global_position += -global_transform.basis.z * speed * delta
	
	var rot_speed = (right_crank.power - left_crank.power) * delta
	rot_speed = move_toward(rot_speed, 0, rotation_resistance)
	var local_y = global_transform.basis.y
	global_transform.basis = global_transform.basis.rotated(local_y, rot_speed * delta)
	
	# Debug info prints
	print_time += delta
	if print_time / 1.0 > 1.0:
		print_time = 0
		print("=================================================")
		print("Velocity: " + str(velocity))
		print("Speed (forward): " + str(speed))
		print("Rotation Speed: " + str(rot_speed))
		print("Rotation: " + str(rotation))
	
# ==============================================================================
# Vehicle Embark / Disembark

func _on_cabin_trigger_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerTwin"):
		print("Vehicle entered")
		var vehicle_node = self
		reparent_player(area, vehicle_node)
		
func _on_cabin_trigger_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerTwin"):
		print("Vehicle exited")
		var world_node = get_tree().current_scene
		reparent_player(area, world_node)
		 
func reparent_player(area: Area3D, parent: Node3D):
# Turn off Area3D monitoring so when scene tree changes,
# the player doesn't send an Area Exited signal
	var player = area.player
	player.reparent(parent, true)
	
	# Smoothly reset local rotation to zero
	var tween = create_tween()
	tween.tween_property(player,"rotation", Vector3.ZERO, 0.5).set_trans(Tween.TRANS_SINE)
	print("trigger")
