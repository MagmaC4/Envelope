extends Node2D

@onready var radius: float = $Sprite2D.texture.get_width() / 2.0
var left_engine: float = 0.0
var right_engine: float = 0.0

@export var mag := 1.0
@export var mass := 1.0

var speed = 0.0
var w = 0.0 # Angular velocity

func _physics_process(delta: float) -> void:
	# Handle Engine Inputs & Decay (Clamped between 0.0 and 1.0)
	if Input.is_action_pressed("move_left"):
		left_engine = move_toward(left_engine, 1.0, 1.0 * delta)
	else:
		left_engine = move_toward(left_engine, 0.0, 5 * delta)
		
	if Input.is_action_pressed("move_right"):
		right_engine = move_toward(right_engine, 1.0, 1.0 * delta)
	else:
		right_engine = move_toward(right_engine, 0.0, 5 * delta)
		
	print("left ", left_engine)
	print("right ", right_engine)
		
	#alculate Forces 
	var total_force = mag * (left_engine + right_engine)
	var cw_torque = mag * left_engine
	var ccw_torque = mag * right_engine
	var torque = ccw_torque - cw_torque
	
	#Apply Forces to Velocity / Angular Velocity (kinda setting mass and moi to zero don't know)
	speed += total_force * delta
	w += torque * delta
	
	# Decay so they approach 0 when untouched
	speed = move_toward(speed, 0.0, 3 * delta)
	w = move_toward(w, 0.0, 4.5 * delta)
	
	position += Vector2.from_angle(rotation) * speed * delta
	rotate(w * delta)
