extends Node3D

@onready var audio : AudioStreamPlayer3D = $AudioStreamPlayer3D

enum State {
	IN_CONTAINER,
	HELD
}
	
func handle_grab():
	audio.play()
	var envelope = get_tree().get_first_node_in_group("Envelope")
	if envelope.state == State.HELD:
		envelope.move_envelope($Marker3D, State.IN_CONTAINER)
	elif envelope.state == State.IN_CONTAINER:
		envelope.move_envelope(get_tree().get_first_node_in_group("Player").get_node("Camera3D/Marker3D"), State.HELD)
	
