extends Node3D

@onready var RopeMesh := $RopeMesh
@onready var RopeArea := $Area3D
@onready var audio_ignite : AudioStreamPlayer3D = $AudioIgnite

signal rope_pulled()

# Tween stuff
@onready var ON_POSITION_Y = RopeMesh.position.y - 0.25
@onready var OFF_POSITION_Y = RopeMesh.position.y
var TRANS_MODE = Tween.TRANS_BACK
var TWEEN_DURATION = 0.25
	
func handle_grab():
	# Disable rope from being grabbed
	RopeArea.remove_from_group("Grabbable")
	
	# Turn on burner / make it more powerful
	rope_pulled.emit()
	
	# decrease ignite volume so sound doesn't clip on repeated rope pulls
	audio_ignite.play()
	
	# move rope down when grabbed
	var position_tween = create_tween()
	position_tween.tween_property(RopeMesh, "position:y", ON_POSITION_Y, TWEEN_DURATION).set_trans(TRANS_MODE)
	position_tween.tween_property(RopeMesh, "position:y", OFF_POSITION_Y, TWEEN_DURATION).set_trans(TRANS_MODE)
	
	# Enable rope being grabbed again
	await position_tween.finished
	RopeArea.add_to_group("Grabbable", false)
	
