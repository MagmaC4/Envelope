extends Node3D

# Local Movement
@onready var cabin_trigger: Area3D = $CabinTrigger
@onready var left_crank: Node3D = $Crank
@onready var right_crank: Node3D = $Crank2
@onready var rope: Node3D = $Rope
var debug = false

# Move up and down
@onready var start_pos = position
@onready var end_pos = start_pos + 3 * Vector3.UP
var direction_up = true
var can_move = true
var vertical_vel = 0.0
var UP_SPEED = .1
var GRAVITY = 5
# Gauges
@onready var altimeter = $Altimeter
@onready var thermometer = $Thermometer

func _ready() -> void:
	#begin_up_down()
	#begin_sway()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	var rope = $Rope
	rope.global_rotation = Vector3.ZERO
	
	# Set altimeter gauge's value with height
	altimeter.value = global_position.y
	
	# Set thermometer gauge's value with burner power
	thermometer.value = rope.power
	handle_up(delta)
	
func handle_up(delta):
	vertical_vel = rope.power * UP_SPEED * delta 
	vertical_vel -= GRAVITY * delta
	position.y += vertical_vel
	global_position.y = clamp(global_position.y, 0.5, 50)
	if (global_position.y < .5):
		vertical_vel = 0
	if debug:
		print(global_position)
		print(vertical_vel)


# Use Tweens (lightweight animation keyframes) to move balloon up and down
func begin_up_down():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position", start_pos, 2.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", end_pos, 2.0).set_trans(Tween.TRANS_QUAD)
	
func begin_sway():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "rotation:z", deg_to_rad(15), 3.0 )
	tween.tween_property(self, "rotation:z", 0.0, 3.0 )
	tween.tween_property(self, "rotation:z", deg_to_rad(-15), 3.0 )
	tween.tween_property(self, "rotation:z", 0.0, 3.0 )

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
		
