extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	get_node("anim").play("dash_trail")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_anim_animation_finished(anim_name):
	if anim_name == "dash_trail":
		self.queue_free()
		
