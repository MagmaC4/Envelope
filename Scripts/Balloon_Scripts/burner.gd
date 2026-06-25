extends StaticBody3D

@onready var rope = get_tree().get_first_node_in_group("Vehicle").get_node("Rope")
@onready var emitter1 = $GPUParticles3D
@onready var emitter2 = $GPUParticles3D2
@onready var emitter3 = $GPUParticles3D3

func _ready():
	emitter1.emitting = false
	emitter2.emitting = false
	emitter3.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emit_on_level()
	

func emit_on_power():
	var power = rope.power
	emitter1.emitting = power > 0
	emitter2.emitting = power >= 33
	emitter3.emitting = power >= 66

# emit particles based on rope's burner level
func emit_on_level():
	var burner_level = rope.burner_level
	emitter1.emitting = burner_level >= 1
	emitter2.emitting = burner_level >= 2
	emitter3.emitting = burner_level >= 3

		
