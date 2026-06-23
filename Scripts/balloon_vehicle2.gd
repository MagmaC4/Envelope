extends AnimatableBody3D

@onready var left_crank: Node3D = $Crank
@onready var right_crank: Node3D = $Crank2
@onready var rope: Node3D = $Rope

@onready var altimeter = $Altimeter
@onready var thermometer = $Thermometer

@onready var radius_to_fan

var g = 1
var max_fall = -10
var max_rise = 10
var velocity: Vector3
var air_resistance : float = 1
var rotation_resistance:= 1.0

var rot_vel: float

func _ready() -> void:
	velocity = Vector3.ZERO
	rot_vel = 0
	var shape : BoxShape3D = $CollisionShape3D.shape
	radius_to_fan = shape.size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rope.global_rotation = Vector3.ZERO
	velocity.y += -g*delta + rope.power * delta * .05
	
	velocity.y = clamp(velocity.y, max_fall, max_rise)
	print(velocity.y)
	
	velocity.x += (-air_resistance + (left_crank.power + right_crank.power)*.05)*delta
	velocity.x
	
	move_and_collide(delta*velocity)
	# Set altimeter gauge's value with height
	altimeter.value = global_position.y
	
	# Set thermometer gauge's value with burner power
	thermometer.value = rope.power
	
	
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
