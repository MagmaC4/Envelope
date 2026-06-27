extends Node3D

# Nodes
@onready var switch : AudioStreamPlayer3D = $Switch
@onready var stations := [
	$Station1,
	$Station2,
	$Station3
]
var switch_on_crash := true

# Channel Control
const MAX_STATION := 3
var current_station := MAX_STATION
var has_started = false

func switch_station():
	current_station += 1
	switch.play()
	
	# mute all stations
	for station in stations:
		station.volume_db = -80
	
	# this is "OFF" (think of it as the final station)
	if current_station == MAX_STATION:
		return
		
	# set current_station index to beginning
	elif current_station > MAX_STATION:
		current_station = 0
	
	# turn up volume on current station
	var tween = create_tween()
	tween.tween_property(stations[current_station], "volume_db", 0, 0.8)
	
func initialize_stations():
	if not has_started:
		for station in stations:
			station.play() 
		has_started = true
	
func handle_grab():
	initialize_stations()
	switch_station()
	
func crash():
	initialize_stations()
	if switch_on_crash:
		switch_on_crash = false
		switch_station()
		await get_tree().create_timer(10.0).timeout
		switch_on_crash = true
		
	
	
