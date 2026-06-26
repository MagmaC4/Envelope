extends StaticBody3D

# Nodes
@onready var rope = get_tree().get_first_node_in_group("Vehicle").get_node("Rope")
@onready var timer = $Timer
@onready var audio_burner : AudioStreamPlayer3D = $AudioBurner
@onready var emitter1 = $GPUParticles3D
@onready var emitter2 = $GPUParticles3D2
@onready var emitter3 = $GPUParticles3D3

# Burner stuff
var MAX_POWER := 100.0
var power := 0.0
var is_burner_on := false
var BURNER_LEVEL_DURATION := 5.0
var MAX_BURNER_LEVEL := 3
var burner_level := 0 # States: 0, 1, 2

# ==============================================================================
# Setup
func _ready():
	rope.rope_pulled.connect(_on_rope_pulled)
	emitter1.emitting = false
	emitter2.emitting = false
	emitter3.emitting = false
	audio_burner.play()
	audio_burner.volume_db = -100

func _process(delta: float) -> void:
	handle_burner(delta)
	emit_on_level()
	
# ==============================================================================
# Control burner power
func handle_burner(delta: float) -> void:
	power += delta * burner_level * 15
	power -= delta * 5
	power = clamp(power, 0, MAX_POWER)
	
	# audio_burner.volume_linear = lerp(0.0, 1.0, power / MAX_POWER)
	var t = float(burner_level) / MAX_BURNER_LEVEL
	audio_burner.volume_linear = lerp(audio_burner.volume_linear, t * 0.5, delta)
	
func _on_rope_pulled(): 
	# Increment burner level
	burner_level = clamp(burner_level + 1, 0, MAX_BURNER_LEVEL)
	timer.start()

func _on_timer_timeout() -> void:
	# Decrement burner level
	burner_level = clamp(burner_level - 1, 0, 3)

# ==============================================================================
# Particles
func emit_on_power():
	emitter1.emitting = power > 0
	emitter2.emitting = power >= 33
	emitter3.emitting = power >= 66

# emit particles based on rope's burner level
func emit_on_level():
	emitter1.emitting = burner_level >= 1
	emitter2.emitting = burner_level >= 2
	emitter3.emitting = burner_level >= 3
	
# ==============================================================================
# Debug (call this function in ready)
func print_burner_info():
	print("=================================================")
	print("BURNER INFORMATION")
	print("Burner level: " + str(burner_level))
	print("Burner power: " + str(power))
	print("Burner audio volume: " + str(audio_burner.volume_linear))
	await get_tree().create_timer(1.0).timeout
	print_burner_info() # recursively call itself
