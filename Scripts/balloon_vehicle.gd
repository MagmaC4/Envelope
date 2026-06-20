extends Node3D

# Local Movement
@onready var cabin_trigger: Area3D = $CabinTrigger

# Move up and down
@onready var start_pos = position
@onready var end_pos = start_pos + 3 * Vector3.UP
var direction_up = true
var can_move = true

func _ready() -> void:
	begin_up_down()
	begin_sway()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Use Tweens (lightweight animation keyframes) to move balloon up and down
func begin_up_down():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position", start_pos, 2.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", end_pos, 2.0).set_trans(Tween.TRANS_QUAD)
	
func begin_sway():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "rotation:z", deg_to_rad(15), 3.0 )
	tween.tween_property(self, "rotation:z", 0.0, 3.0 )
	tween.tween_property(self, "rotation:z", deg_to_rad(-15), 3.0 )
	tween.tween_property(self, "rotation:z", 0.0, 3.0 )
	
# Make player position local to the vehicle 
func _on_cabin_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Vehicle entered")
		var vehicle_node = self
		body.reparent(vehicle_node, true)
		
		# Smoothly reset local rotation to zero
		var tween = create_tween()
		tween.tween_property(body,"rotation", Vector3.ZERO, 0.5)
		
# Make player position local to the world
func _on_cabin_trigger_body_exited(body: Node3D) -> void:
	pass
	#if body.is_in_group("Player"):
		#print("Vehicle exited")
		#var world_node = get_tree().current_scene
		#reparent_player(body, world_node)
	
		
		
func reparent_player(body: CharacterBody3D, parent: Node3D):
# Turn off Area3D monitoring so when scene tree changes,
# the player doesn't send an Area Exited signal
	cabin_trigger.set_deferred("monitoring", false)
	body.call_deferred("reparent", parent, true)
	await get_tree().create_timer(0.1).timeout
	cabin_trigger.set_deferred("monitoring", true)
	
	
		
