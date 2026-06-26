extends Node3D

@export var crank : Node3D
@onready var blade : Node3D = $Blade
@onready var audio : AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready():
	audio.play()


func _process(delta: float) -> void:
	blade.rotate_x(crank.power * delta)
	audio.volume_linear = crank.power / 100.0 * 0.2
