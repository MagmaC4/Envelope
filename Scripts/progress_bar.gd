extends Node3D

@onready var crank : Node3D = get_parent()
@onready var progress_bar : TextureProgressBar = $SubViewport/TextureProgressBar
@onready var progress_sprite : Sprite3D = $Sprite3D

func _ready():
	if not crank.on_left:
		progress_sprite.flip_v = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = crank.power
