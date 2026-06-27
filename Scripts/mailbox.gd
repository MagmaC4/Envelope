extends Node3D

enum State {
	IN_CONTAINER,
	HELD
}


func handle_grab():
	var envelope = get_tree().get_first_node_in_group("Envelope")
	if envelope.state == State.HELD:
		envelope.move_envelope(self, State.IN_CONTAINER)
		envelope.visible = false
		finish_game()

func finish_game():
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	var credits = get_tree().get_first_node_in_group("UI").get_node("Credits")
	credits.visible = true
	credits.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(credits, "modulate:a", 1.0, 2.0)
	await tween.finished
	await get_tree().create_timer(10.0).timeout
	tween.tween_property(credits, "modulate:a", 0.0, 2.0)
	credits.visible = false
