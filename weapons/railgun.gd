extends "res://weapons/weapon_base.gd"

export(int) var damage

onready var ray = get_node("raycast")
onready var trail_effect = get_node("trail_effect")

var ray_x = 0
var ray_y = 0
var ray_hit = Vector2()
var trail

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	ray.position = GLOBAL.player.position
	bullet = null
	trail = preload("res://projectiles/rail_trail.tscn")

func _physics_process(delta):
	
	ray.position = GLOBAL.player.position
	
	ray_x = 0
	ray_y = 0

	if can_shoot:
	
		if Input.is_action_pressed("shoot_up"):
			GLOBAL.weapon_cooldown_timer.value = 0
			GLOBAL.update_cooldown(shot_delay)
			ray_y = -2000
			can_shoot = false
			
		if Input.is_action_pressed("shoot_right"):
			GLOBAL.weapon_cooldown_timer.value = 0
			GLOBAL.update_cooldown(shot_delay)
			ray_x = 2000
			can_shoot = false
				
		if Input.is_action_pressed("shoot_down"):
			GLOBAL.weapon_cooldown_timer.value = 0
			GLOBAL.update_cooldown(shot_delay)
			ray_y = 2000
			can_shoot = false
				
		if Input.is_action_pressed("shoot_left"):
			GLOBAL.weapon_cooldown_timer.value = 0
			GLOBAL.update_cooldown(shot_delay)
			ray_x = -2000
			can_shoot = false
			
		ray.cast_to = Vector2(ray_x, ray_y)
		ray.force_raycast_update()
		ray_hit = ray.get_collision_point()
		
		if ray.is_colliding():
			if trail_effect.get_point_count() > 0:
				trail_effect.remove_point(0)
			var collider = ray.get_collider()
			if collider.is_in_group("enemies"):
				collider.take_damage(damage)
			
			GLOBAL.player.railgun = true	
				
			var t = trail.instance()
			GLOBAL.world.add_child(t)
			t.set_position(ray_hit)
		
			trail_effect.add_point(ray.position)
			trail_effect.add_point(ray_hit)
			get_node("anim").play("fade")
			
		timer.start()	

func _on_anim_animation_finished(anim_name):
	if anim_name == "fade":
		trail_effect.remove_point(0)
