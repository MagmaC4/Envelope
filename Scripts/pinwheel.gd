extends Node3D

@onready var sprite : Sprite3D = $Sprite3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.rotation.z += delta * 2 * PI
