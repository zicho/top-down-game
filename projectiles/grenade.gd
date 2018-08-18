extends RigidBody2D

var effect = preload("res://effects/explosion.tscn")
var explode_timer
var explode_start = true

func _ready():
	
	add_to_group("projectiles")
	explode_timer = Timer.new()
	explode_timer.set_one_shot(true)
	explode_timer.set_wait_time(2)
	explode_timer.connect("timeout", self, "explode")
	add_child(explode_timer)
	explode_timer.start()

func explode():
	self.queue_free()
	var effect_instance = effect.instance()
	effect_instance.position = position
	GLOBAL.world.add_child(effect_instance)

func _physics_process(delta):
	
	if explode_timer.time_left < 1:
		set_collision_mask(1)
	
	var collision_list = get_colliding_bodies()
	for c in collision_list:
		if c.is_in_group("enemies") \
		and c.ACTIVE \
		and explode_timer.time_left > 1:
			set_collision_mask(1)
			explode()