extends Node3D

@onready var RopeMesh := $RopeMesh
@onready var RopeArea := $Area3D
@onready var audio_ignite : AudioStreamPlayer3D = $AudioIgnite
@onready var audio_burner : AudioStreamPlayer3D = $AudioBurner

# Burner stuff
var MAX_POWER := 100.0
var power := 0.0
var is_burner_on := false
var BURNER_LEVEL_DURATION := 5.0
var MAX_BURNER_LEVEL := 3
var burner_level := 0 # States: 0, 1, 2

# Tween stuff
var ON_POSITION_Y = -1.0
var OFF_POSITION_Y = -0.75
var TRANS_MODE = Tween.TRANS_BACK
var TWEEN_DURATION = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_burner.play()
	audio_burner.volume_db = -100
	# print_burner_info())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_burner(delta)
	
func handle_grab():
	# Disable rope from being grabbed
	RopeArea.remove_from_group("Grabbable")
	
	# Turn on burner / make it more powerful
	increase_burner_level()
	
	# decrease ignite volume so sound doesn't clip on repeated rope pulls
	audio_ignite.play()
	
	# move rope down when grabbed
	var position_tween = create_tween()
	position_tween.tween_property(RopeMesh, "position:y", ON_POSITION_Y, TWEEN_DURATION).set_trans(TRANS_MODE)
	position_tween.tween_property(RopeMesh, "position:y", OFF_POSITION_Y, TWEEN_DURATION).set_trans(TRANS_MODE)
	
	# Enable rope being grabbed again
	await position_tween.finished
	RopeArea.add_to_group("Grabbable", false)
	
func handle_burner(delta: float) -> void:
	power += delta * burner_level * 15
	power -= delta * 5
	power = clamp(power, 0, MAX_POWER)
	
	# audio_burner.volume_linear = lerp(0.0, 1.0, power / MAX_POWER)
	var t = float(burner_level) / MAX_BURNER_LEVEL
	audio_burner.volume_linear = lerp(audio_burner.volume_linear, t, delta)
	
func increase_burner_level():
	# Do nothing if burner level = max
	if burner_level == MAX_BURNER_LEVEL:
		return
	
	# Increment burner level
	burner_level = clamp(burner_level + 1, 0, 3)
	# Create timer to decrease burner level
	await get_tree().create_timer(BURNER_LEVEL_DURATION).timeout
	# Decrement burner level
	burner_level = clamp(burner_level - 1, 0, 3)
	
func print_burner_info():
	# Debug prints
	print("=================================================")
	print("BURNER INFORMATION")
	print("Burner level: " + str(burner_level))
	print("Burner power: " + str(power))
	print("Burner audio volume: " + str(audio_burner.volume_linear))
	await get_tree().create_timer(1.0).timeout
	print_burner_info()
