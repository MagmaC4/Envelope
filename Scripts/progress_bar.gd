extends Node3D

@onready var crank : Node3D = get_parent()
@onready var progress_bar : TextureProgressBar = $SubViewport/TextureProgressBar
@onready var progress_sprite : Sprite3D = $Sprite3D

func _ready():
	# Flip arrow to face the right direction
	if not crank.on_left:
		progress_sprite.flip_v = true
		

func _process(delta: float) -> void:
	# Progress bar represents crank's stored power
	progress_bar.value = crank.power
