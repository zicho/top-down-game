extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const weapon_colors = {
    machine_gun = "FFD700",
    rocket_launcher = "E60000",
	grenade_launcher = "00CC00",
	railgun = "FF00FF",
}

onready var world
onready var player
onready var weapon_cooldown_timer
onready var weapon_cooldown_tween = Tween.new()

func _ready():

	var game_root = get_tree().get_root().get_node("Main")
	if game_root:
		world = game_root.find_node("world")
		weapon_cooldown_timer = game_root.find_node("weapon_cooldown_timer")

	else:
		world = get_tree().get_root()
		
	#world = get_tree().get_root().get_node("colworld")

	if world:
		player = world.find_node("player")
	
	add_child(weapon_cooldown_tween)
	

func update_cooldown(delay):
	
	weapon_cooldown_tween.interpolate_property(weapon_cooldown_timer, "value", 0, 100, delay, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	weapon_cooldown_tween.start()