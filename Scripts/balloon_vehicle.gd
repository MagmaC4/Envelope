extends Node3D

# Local Movement
@onready var cabin_trigger: Area3D = $CabinTrigger

# Move up and down
@onready var start_pos = position
@onready var end_pos = start_pos + 3 * Vector3.UP
var direction_up = true
var can_move = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_up_and_down()

# Use Tweens (lightweight animation keyframes) to move balloon up and down
func move_up_and_down():
	if direction_up and can_move:
		var tween = create_tween()
		tween.tween_property(self, "position", end_pos, 1.0).set_trans(Tween.TRANS_QUAD)
		direction_up = !direction_up
		can_move = false
		await tween.finished
		can_move = true
	elif not direction_up and can_move:
		var tween = create_tween()
		tween.tween_property(self, "position", start_pos, 1.0).set_trans(Tween.TRANS_QUAD)
		direction_up = !direction_up
		can_move = false
		await tween.finished
		can_move = true
	


	
	
		
