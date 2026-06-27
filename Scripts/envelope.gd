extends Node3D

enum State {
	IN_CONTAINER,
	HELD
}

var state = State.HELD
var holder : Node3D = null

func move_envelope(new_parent : Node3D, new_state : State):
	holder = new_parent
	state = new_state
	
	reparent(holder)
	position = Vector3.ZERO
	rotation = Vector3.ZERO
