extends Path3D

@onready var path_follow : PathFollow3D = $PathFollow3D
@onready var rotating_node : Node3D = $PathFollow3D/Node3D 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow.progress_ratio += delta / 10
	
	# rotate
	rotating_node.rotate(rotating_node.basis.x, delta * 20)
	
	# displace position
	var t = Time.get_ticks_msec() * 0.001
	position += Vector3.UP * sin(t) * delta * 2
