extends "res://enemies/base_enemy.gd"

onready var detect_range = get_node("detect_range")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	CHASE = false
	AGGR = false
	WAKE_ON_ENTER = true
	
	hp = 20

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

func _on_detect_range_body_entered(body):
	
	if body.get_name() == "player":
		print("entered LOS of %s" % get_name())
		if player_in_LOS():
			activate()
			self.CHASE = true
		
func _on_detect_range_body_exited(body):
	if body.get_name() == "player" and not AGGR:
		CHASE = false

