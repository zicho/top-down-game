extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 240 # Pixels/second

signal move
onready var weapon

var can_dash = true
var is_dashing = false
var dash_timer = Timer.new()
var dash_cooldown = Timer.new()
onready var dash_trail = preload("res://effects/dash_trail.tscn")

var hit_stun = 0
var knock_dir = Vector2(0,0)

var health = 10

enum weapons {
	machine_gun,
	rocket_launcher,
	grenade_launcher,
	railgun
}

var weapon_queue = null

onready var rocket_launcher = true
onready var grenade_launcher = true
onready var railgun = true

func _ready():
	
	weapon = preload("res://weapons/pistol.tscn" ).instance()
	add_child(weapon)
	
	dash_timer.connect("timeout", self, "can_dash")
	dash_timer.set_one_shot(true)
	dash_timer.set_wait_time(1)
	add_child(dash_timer)
	
	dash_cooldown.connect("timeout", self, "dash_ended")
	dash_cooldown.set_one_shot(true)
	dash_cooldown.set_wait_time(0.2)
	add_child(dash_cooldown)
	
	switch_weapon(weapons.machine_gun)

func take_knockback(damage, from_pos, knockback_strength):
	
	if hit_stun > 0:
		hit_stun -= 1
	
	if hit_stun == 0:
		self.health -= damage
		hit_stun = knockback_strength
		knock_dir = transform.origin - from_pos.origin

func can_dash():
	can_dash = true	

func dash_ended():
	MOTION_SPEED = 240
	is_dashing = false

func switch_to_queued_weapon():
	if weapon_queue != null:
		switch_weapon(weapon_queue)

func switch_weapon(weapon_name):
	
	weapon_queue = null
	
	if weapon.can_shoot:
		
		remove_child(weapon)
	
		if weapon_name == weapons.machine_gun:
			weapon = preload( "res://weapons/pistol.tscn" ).instance()
			add_child(weapon)
			GLOBAL.weapon_cooldown_timer.modulate = GLOBAL.weapon_colors.machine_gun
			
		if weapon_name == weapons.rocket_launcher:
			weapon = preload( "res://weapons/rocket_launcher.tscn" ).instance()
			add_child(weapon)
			GLOBAL.weapon_cooldown_timer.modulate = GLOBAL.weapon_colors.rocket_launcher
			
		if weapon_name == weapons.grenade_launcher:
			weapon = preload( "res://weapons/grenade_launcher.tscn" ).instance()
			add_child(weapon)
			GLOBAL.weapon_cooldown_timer.modulate = GLOBAL.weapon_colors.grenade_launcher
			
		if weapon_name == weapons.railgun:
			weapon = preload( "res://weapons/railgun.tscn" ).instance()
			add_child(weapon) 
			GLOBAL.weapon_cooldown_timer.modulate = GLOBAL.weapon_colors.railgun
			
	else:
		weapon_queue = weapon_name		

func _physics_process(delta):
	
	if hit_stun != 0:
		hit_stun -=1
	
	var motion = Vector2()

	if Input.is_action_pressed("ui_select"):
		if can_dash:
			can_dash = false
			MOTION_SPEED = 360
			dash_cooldown.start()
			is_dashing = true
			dash_timer.start()
	
	if is_dashing:
		var trail = dash_trail.instance()
		trail.position = position
		GLOBAL.world.add_child(trail)
	
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("move_bottom"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)

	
	if Input.is_action_pressed("weapon_1"):
		switch_weapon(weapons.machine_gun)
		
	if Input.is_action_pressed("weapon_2") and rocket_launcher:
		switch_weapon(weapons.rocket_launcher)
			
	if Input.is_action_pressed("weapon_3") and grenade_launcher:
		switch_weapon(weapons.grenade_launcher)
			
	if Input.is_action_pressed("weapon_4") and railgun:
		switch_weapon(weapons.railgun)

	if hit_stun == 0:
		motion = motion.normalized() * MOTION_SPEED
	else:
		motion = knock_dir.normalized() * MOTION_SPEED * 1.5	
		
	move_and_slide(motion)

	#var collision = move_and_collide(motion * delta)
	
	
	emit_signal("move")