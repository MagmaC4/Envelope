extends Node3D

@onready var dial = $dial

# angle
@export var MIN_ANGLE = 0.0
@export var MAX_ANGLE = 2.0 * PI
var angle = MIN_ANGLE
@export var is_clockwise = false
@onready var dir = -1 if is_clockwise else 1


# value
@export var MAX_VALUE = 100.0 # this needs to be accurate 
var value = 0.0

# animation
var tween : Tween
var is_max = false

func _process(delta: float) -> void:
	
	if not is_max:
		# Change dial angle based on proportional value
		var proportion = clamp(value / MAX_VALUE, 0, 1)
		dial.rotation.y = dir * lerp(MIN_ANGLE, MAX_ANGLE, proportion) # negative		
		
	# Start max dial animation when past MAX_VALUE
	if value >= MAX_VALUE:
		# increase speed of max dial anim when approaching higher values
		var tween_speed = clamp(value / MAX_VALUE, 1.0, 5.0)
		if tween:
			tween.set_speed_scale(tween_speed)
		
		# being tween if it is not enabled
		if !is_max:
			is_max = true
			max_dial()
	else:
		is_max = false
		if tween: 
			tween.kill() # pause max value animation

# Animation that twitches the dial once max value is reached
func max_dial():
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(dial, "rotation:y", dir * (MAX_ANGLE), 0.3).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(dial, "rotation:y", dir * (MAX_ANGLE * 0.95), 0.3).set_trans(Tween.TRANS_SPRING)
	
