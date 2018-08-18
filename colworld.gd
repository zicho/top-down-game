extends Node2D

onready var window_size = get_viewport_rect().size
onready var player = get_node("player")
onready var player_world_pos = get_player_grid_pos()

onready var pathfinder = get_node("pathfinder")

onready var LIGHT = false

func _ready():

	var canvas_transform = get_canvas_transform()
	canvas_transform[2] = player_world_pos * window_size
	get_viewport().set_canvas_transform(canvas_transform)
	update_camera()
	
	if LIGHT:
		get_node("room_1/darkness").visible = true
		GLOBAL.player.get_node("torch").enabled = true

func get_player_grid_pos():

	var pos = player.get_position()
	return Vector2(floor(pos.x / window_size.x), floor(pos.y / window_size.y))

func update_camera():

	var new_player_grid_pos = get_player_grid_pos()
	var transform 

	if new_player_grid_pos != player_world_pos:
		player_world_pos = new_player_grid_pos
		transform = get_canvas_transform()
		transform[2] = -player_world_pos * window_size
		get_viewport().set_canvas_transform(transform)
	return transform

func _on_player_move():
	update_camera()
