extends "res://projectiles/projectile_base.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var effect = preload("res://effects/explosion.tscn")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	MOTION_SPEED += 24
	
func on_hit_effect():
	var effect_instance = effect.instance()
	effect_instance.position = position
	GLOBAL.world.add_child(effect_instance)
	