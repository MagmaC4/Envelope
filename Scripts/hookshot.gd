extends Node3D
var state := 0
#-1 = down
#0 = retracted
#1 = flying
#2 = Coming back
@onready var player = $"../.."
@onready var targettingray = $"../Target"
var target
var hooked : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hook.position = Vector3(0.863, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == -1:
		if Input.is_action_just_pressed("Down"):
			$AnimationPlayer.play("Up")
			show()
			await $AnimationPlayer.animation_finished
			state = 0
	elif state == 0:
		if Input.is_action_just_pressed("grab"):
			state = 1
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			player.stuck = true
			$Length.start()
			if targettingray.is_colliding():
				target = targettingray.get_collision_point()
				
			else:
				target = to_global(targettingray.target_position)
			look_at(target)
			rotate_y(deg_to_rad(-90))
			#shoots the hook out
		elif Input.is_action_just_pressed("Down"):
			state = -1
			$AnimationPlayer.play("Down")
			await $AnimationPlayer.animation_finished
			hide()
			
			
	if (Input.mouse_mode == Input.MOUSE_MODE_HIDDEN):
		if state == 1:
			var col = $Hook/RayCast3D.get_collider()
			if not col:
				$Hook.position.x -= 15 * delta
			else:
				
				if $Hook/RayCast3D.get_collider().is_in_group("Item"):
					hooked = $Hook/RayCast3D.get_collider().get_parent()
					hooked.reparent($Hook/Item_Holder)
					
				state = 2
		elif state == 2:
			if $Hook.position.x < 0.863:
				$Hook.position.x += 30 * delta
			else:
				$Hook.position.x = 0.863
				state = 0
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				player.stuck = false


func _on_length_timeout() -> void:
	if state == 1:
		state = 2
