extends Control

@onready var player = get_tree().get_first_node_in_group("Player")
var in_menu := false

func _process(delta):
	# Turn on settings menu when player presses ESC
	if Input.is_action_just_pressed("ui_cancel"):
		if not visible:
			settings_on()
		else:
			settings_off()
		
func settings_on():
	visible = true
	in_menu = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func settings_off():
	visible = false
	in_menu = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_exit_pressed() -> void:
	settings_off()

func _on_volume_value_changed(value: float) -> void:
	var volume = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(0, volume)

func _on_mouse_sensitivity_value_changed(value: float) -> void:
	var camera = player.get_node("Camera3D")
	camera.camera_sensitivity_mouse = value / 10


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			# Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:
			# Windowed Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: 
			# Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/master.tscn")
