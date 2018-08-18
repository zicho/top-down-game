extends KinematicBody2D

const MOTION_SPEED = 100 # Pixels/second
const CHASE_SPEED = 50 # GETS ADDED TO MOVE SPEED ON CHASING

const center = Vector2(0, 0)
const up = Vector2(0, -1)
const right = Vector2(1, 0)
const down = Vector2(0, 1)
const left = Vector2(-1, 0)

var movedir = center

var hp
var damage = 2
var knockback_strength = 20

var movetimer_length = 30
var movetimer = 0

var delta_stored = 0

onready var ACTIVE = false
onready var WAKE_ON_ENTER = false

# STATES
onready var CHASE = false
onready var AGGR = false

func _ready():
	
	deactivate()
	add_to_group("enemies")
	hp = 1

func take_damage(damage):
	
	if ACTIVE:
		hp -= damage
		
		var anim = find_node("anim")
		if anim: anim.play("is_hit")
		
		if hp <= 0:
			self.queue_free()
			if self.has_method("on_death"):
				self.on_death()	
			
			
		if self.has_method("on_hit_effect"):
			self.on_hit_effect()

func player_in_LOS():

	if GLOBAL.player:
		var space_state = get_world_2d().direct_space_state
	#	var target_extents = GLOBAL.player.get_node("hitbox").shape.extents - Vector2(2,2)
	#
	#	var NW = GLOBAL.player.global_position - target_extents
	#	var SE = GLOBAL.player.global_position + target_extents
	#	var NE = GLOBAL.player.global_position + Vector2(target_extents.x, -target_extents.y)
	#	var SW = GLOBAL.player.global_position + Vector2(-target_extents.x, target_extents.y)
	#
	#	var result
	#
	#	for pos in [NW, SE, NE, SW]:
	#		result = space_state.interset_ray(pos, GLOBAL.player.global_position, [self], get_node("detect_range").collision_mask)
	
		# OLD RAYCAST, FIX NEWER LATER
		var result = space_state.intersect_ray(global_position, GLOBAL.player.global_position, [self], get_node("detect_range").collision_mask)
	
		if result:
			#print (result.collider.get_name())
			#print("Position: %s Result: %s" % [position, result.position])
			if result.collider.get_name() == "player":
				return true

func rand():
	var d = randi() % 4 + 1
	match d:
		1:
			return up
		2:
			return right
		3:
			return down
		4:
			return left

func move():
	
	if not CHASE: 
		if movetimer > 0:
			movetimer -= 1
		if movetimer == 0:
			movedir = rand()
			movetimer = movetimer_length
		
		var motion = movedir.normalized() * MOTION_SPEED
		var collision = move_and_collide(motion * delta_stored)
		
func chase():
	
	var distance_to_player = self.get_global_position().distance_to(GLOBAL.player.get_global_position())
	movedir = (GLOBAL.player.get_global_position() - self.get_global_position()).normalized()
	
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion * delta_stored)
	
	if collision:
		var collider = collision.collider
		
		if collider.get_name() == "player":
			collider.take_knockback(self.damage, self.transform, self.knockback_strength)
	

func _physics_process(delta):
	
	delta_stored = delta
	
	if AGGR:
		CHASE = true
	
	if ACTIVE:
		if CHASE:
			chase()
		else:	
			move()

func activate():
	ACTIVE = true

func deactivate():
	ACTIVE = false
