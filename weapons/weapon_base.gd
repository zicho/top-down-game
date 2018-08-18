extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var can_shoot = true
var timer = Timer.new()

export var shot_delay = 0.2
var bullet = preload("res://projectiles/bullet.tscn")

signal shot_ready

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	timer.connect("timeout", self, "can_shoot")
	timer.set_wait_time(shot_delay)
	add_child(timer)
	
	connect("shot_ready", GLOBAL.player, "switch_to_queued_weapon")
	
func can_shoot():
	can_shoot = true
	emit_signal("shot_ready")

func _physics_process(delta):

	if can_shoot:
		
		if bullet:
			
			var bullet_instance = bullet.instance()
			bullet_instance.position = get_parent().position
			
			if Input.is_action_pressed("shoot_up"):
				can_shoot = false
				bullet_instance.motion += Vector2(0, -1)
				
			if Input.is_action_pressed("shoot_right") and not Input.is_action_pressed("shoot_left"):
				can_shoot = false
				bullet_instance.motion += Vector2(1, 0)
				
			if Input.is_action_pressed("shoot_down") and not Input.is_action_pressed("shoot_up"):
				can_shoot = false
				bullet_instance.motion += Vector2(0, 1)
				
			if Input.is_action_pressed("shoot_left"):
				can_shoot = false
				bullet_instance.motion += Vector2(-1, 0)
				
			if Input.is_action_pressed("shoot_up") \
			or Input.is_action_pressed("shoot_right") \
			or Input.is_action_pressed("shoot_down") \
			or Input.is_action_pressed("shoot_left"):
				GLOBAL.weapon_cooldown_timer.value = 0
				GLOBAL.update_cooldown(shot_delay)
				GLOBAL.world.add_child(bullet_instance)
						
			if bullet_instance.motion == Vector2(0, -1): # GOING UPWARD
				bullet_instance.rotation_degrees = 0
	
			if bullet_instance.motion == Vector2(1, -1): # GOING UPWARD AND RIGHT
				bullet_instance.rotation_degrees = 45
							
			if bullet_instance.motion == Vector2(1, 0): # GOING RIGHT
				bullet_instance.rotation_degrees = 90
				
			if bullet_instance.motion == Vector2(1, 1): # GOING DOWNWARD AND RIGHT
				bullet_instance.rotation_degrees = 135
				
			if bullet_instance.motion == Vector2(0, 1): # GOING DOWNWARD
				bullet_instance.rotation_degrees = 180
				
			if bullet_instance.motion == Vector2(-1, 1): # GOING DOWNWARD AND LEFT
				bullet_instance.rotation_degrees = 225	
				
			if bullet_instance.motion == Vector2(-1, 0): # GOING LEFT
				bullet_instance.rotation_degrees = 270
				
			if bullet_instance.motion == Vector2(-1, -1): # GOING UPWARD AND LEFT
				bullet_instance.rotation_degrees = 315	
				
		
		timer.start()
		
