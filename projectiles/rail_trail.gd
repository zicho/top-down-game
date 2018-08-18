extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	get_node("anim").play("destroy")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "destroy":
		self.queue_free()
