extends Node3D

# Local Movement
@onready var cabin_trigger: Area3D = $CabinTrigger

# Move up and down
@onready var start_pos = position
@onready var end_pos = start_pos + 3 * Vector3.UP
var direction_up = true
var can_move = true

func _ready() -> void:
	begin_up_down()
	begin_sway()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Use Tweens (lightweight animation keyframes) to move balloon up and down
func begin_up_down():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position", start_pos, 1.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", end_pos, 1.0).set_trans(Tween.TRANS_QUAD)
	
func begin_sway():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "rotation:z", deg_to_rad(15), 1.0 )
	tween.tween_property(self, "rotation:z", 0.0, 1.0 )
	tween.tween_property(self, "rotation:z", deg_to_rad(-15), 1.0 )
	tween.tween_property(self, "rotation:z", 0.0, 1.0 )
	

	
	
		
