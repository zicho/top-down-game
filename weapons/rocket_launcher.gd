extends "res://weapons/weapon_base.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	bullet = preload("res://projectiles/rocket.tscn")
