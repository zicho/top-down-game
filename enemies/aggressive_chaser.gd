extends "res://enemies/base_enemy.gd"

onready var detect_range

var SEARCH = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	detect_range = get_node("detect_range")
	CHASE = false
	AGGR = false
	WAKE_ON_ENTER = false
	hp = 200
		
func on_hit_effect():
	
	
	AGGR = true
	CHASE = true
	
func on_death():
	pass

func _physics_process(delta):
	
	if CHASE:
		chase()
		
	if player_in_LOS() and detect_range.overlaps_body(GLOBAL.player):
		activate()
		self.CHASE = true
	
	
#
#func _on_detect_range_body_entered(body):
#
#	if body.get_name() == "player":
#		print("entered LOS of %s" % get_name())
#		if player_in_LOS():
#			pass
#			#activate()
#			#self.CHASE = true

