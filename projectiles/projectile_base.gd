extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var motion = Vector2()
export var MOTION_SPEED = 1200
export var damage = 1
export(bool) var explosive = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("projectiles")

func _physics_process(delta):
	
	motion = motion.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion * delta)
	
	if collision:
		var collider = collision.collider
		
		if collider.is_in_group("enemies") and collider.ACTIVE:
			collider.take_damage(damage)
			
		if collider.is_in_group("destructible") and explosive:
			if collider.has_method("destroy"):
				collider.destroy()
			else:
				collider.queue_free()	
			
		if self.has_method("on_hit_effect"):
			self.on_hit_effect()	
		
		queue_free()