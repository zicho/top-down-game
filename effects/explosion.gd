extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


export(int) var damage
var destroy_timer = Timer.new()

func _ready():

	var anim = get_node("anim")
	anim.play("explode")
	destroy_timer.set_wait_time(0.5)
	destroy_timer.connect("timeout", self, "queue_free")
	add_child(destroy_timer)
	destroy_timer.start()

func _on_explosion_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if body.is_in_group("destructible"):
		body.queue_free()
