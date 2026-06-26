extends Camera3D

@onready var UI = get_tree().get_first_node_in_group("UI")
@export var camera_sensitivity_controller := 100
@export var camera_sensitivity_mouse := 7.5 # 0 - 10
var mouse_input : Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	# Lock mouse to window on ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta: float) -> void:
	# Camera rotates only when mouse is focused
	if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		handle_camera(delta)
		
# Override _input function to keep track of MouseMotion
# event is a variable that records all InputEvents
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative
		
	if event is InputEventMouseButton and event.pressed and not UI.get_node("PauseMenu").in_menu:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	
# handle camera rotation with input event (Mouse)
func handle_camera(delta):
	var look_input = (-1) * mouse_input
	look_input = look_input  * camera_sensitivity_mouse * delta
	# Rotate camera based on look_input vector
	rotation_degrees.x += look_input.y
	rotation_degrees.x = clampf(rotation_degrees.x, -90, 90)
	rotation_degrees.y += look_input.x
	# Reset mouse_input (necessary or else your mouse will feel like it's sliding)
	mouse_input = Vector2.ZERO
