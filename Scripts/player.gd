extends CharacterBody3D


# Interaction
@onready var ray_cast : RayCast3D = $Camera3D/RayCast3D
@onready var crank_ray : RayCast3D = $Camera3D/CrankRay
@onready var crosshair_main : TextureRect = $UI/CrosshairMain
@onready var crosshair_grab : TextureRect = $UI/CrosshairGrab
var is_cranking := false
var crank : Node3D


# Movement
@onready var camera : Camera3D = $Camera3D
var SPEED = 3.5
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:		
	handle_movement(delta)
	handle_raycast()
	if is_cranking:
		handle_crank(delta)
	
func handle_raycast() -> void:
	var col = ray_cast.get_collider()
	
	# Change crosshair if item is grabbable
	if (col and col.is_in_group("Grabbable")) or is_cranking:
		crosshair_main.visible = false
		crosshair_grab.visible = true
	else:
		crosshair_main.visible = true
		crosshair_grab.visible = false
		
	# Send grab signal to Grabbable objects
	if col and col.is_in_group("Grabbable") and Input.is_action_just_pressed("grab"):
		# using heuristic that area is direct child of a scripted object 
		var grabbable_object = col.get_parent() 
		grabbable_object.handle_grab()
	
	# Check if player is looking at crank
	if col and col.is_in_group("Crank"):
		# Enable player's cranking state
		if Input.is_action_pressed("grab"):
			crank = col.get_parent()
			is_cranking = true

func handle_crank(delta):
	# Let crank know to rotate towards player mouse
	var view_pos = crank_ray.get_collision_point()
	crank.handle_rotation(view_pos, delta)
	
	# Stop cranking when player releases grab
	if Input.is_action_just_released("grab"):
		is_cranking = false
		
	
func handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
		
	if get_parent() is AnimatableBody3D:
		platform_floor_layers = 0 
	else:
		platform_floor_layers = 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# set direction of movement relative to camera
	var direction := camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0 # remove y component of camera direction
	direction = direction.normalized() # normalize direction
	
	var sprint_speed = 1
	if (Input.is_action_pressed("sprint")):
		sprint_speed = 1.5
	
	if direction:
		velocity.x = direction.x * SPEED * sprint_speed
		velocity.z = direction.z * SPEED * sprint_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
