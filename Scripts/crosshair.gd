extends Control

@onready var crosshair_main : TextureRect = $CrosshairMain
@onready var crosshair_grab : TextureRect = $CrosshairGrab

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.hovering_grabbable.connect(_on_player_hovering_grabbable)

# Swap crosshair
func _on_player_hovering_grabbable(is_hovering: bool) -> void:
	print("is hovering")
	crosshair_main.visible = !is_hovering
	crosshair_grab.visible = is_hovering
