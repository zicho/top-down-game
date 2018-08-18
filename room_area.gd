extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var _room = get_parent()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	var rect = _room.get_used_rect().size
	var used_cells = _room.get_used_cells()
	
	var x = 0
	var y = 0
	
#	for x in range(rect.x):
#		for y in range(rect.y):
#			var tile_index = _room.get_cell(x, y)
#			if tile_index == -1:
#				_room.set_cell(x, y, 1)

func _on_Area2D_body_entered(body):
	if body.name == "player":
		for e in _room.get_children():
			if e.is_in_group("enemies") and e.WAKE_ON_ENTER:
				e.activate()
