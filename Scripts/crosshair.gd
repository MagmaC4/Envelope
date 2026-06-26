extends Control

@onready var crosshair_main : TextureRect = $CrosshairMain
@onready var crosshair_grab : TextureRect = $CrosshairGrab
var player 
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player:
		
			player.hovering_grabbable.connect(_on_player_hovering_grabbable)

# Swap crosshair
func _on_player_hovering_grabbable(is_hovering: bool) -> void:
	
	print("is hovering")
	if player.get_node('Camera3D/Hookshot').state == -1:
		crosshair_main.visible = !is_hovering
		crosshair_grab.visible = is_hovering
	else:
		crosshair_main.visible = true
		crosshair_grab.visible = false
		
