extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	get_node("anim").play("bounce")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_rocket_launcher_pickup_body_entered(body):
	if body.name == "player":
		queue_free()
		GLOBAL.player.rocket_launcher = true
