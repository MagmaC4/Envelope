extends Node3D

@onready var player = get_tree().get_first_node_in_group("Player")

# Player twin is a area trigger box that follows the player hit box
# This will allow us to reparent the player without interrupting physics processes

func _process(delta: float) -> void:
	if player:
		global_transform = player.global_transform
