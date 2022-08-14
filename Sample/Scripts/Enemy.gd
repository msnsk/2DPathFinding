extends KinematicBody2D

signal enemy_died

const jewel_scn = preload("res://Scenes/Jewel.tscn")

var life: int
var speed = 20
var player
var attacking = false

onready var sprite = $Sprite
onready var nav_agent = $NavigationAgent2D
onready var attack_timer = $AttackTimer
onready var anim_player = $AnimationPlayer
onready var killed_sfx = $KilledSFX


func _ready():
	initialize_params()
	nav_agent.set_target_location(global_position)
	nav_agent.get_next_location()


func initialize_params():
	var random_num = randi() % sprite.hframes
	life = random_num
	sprite.frame = random_num
	sprite.frame = random_num
	speed += (sprite.hframes - random_num) * 4
	sprite.modulate.s = float(random_num) * 0.1


func _physics_process(_delta):
	if anim_player.current_animation == "hit"\
	or anim_player.current_animation == "attack":
		return
	if not nav_agent.is_navigation_finished():
		var current_pos = global_position
		var target = nav_agent.get_next_location()
		var velocity = current_pos.direction_to(target) * speed
		nav_agent.set_velocity(velocity)
		anim_player.play("move")


func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	move_and_slide(safe_velocity)


func _on_PathTimer_timeout():
	nav_agent.set_target_location(player.global_position)
	nav_agent.get_next_location()


func _on_KilledSFX_finished():
	spawn_jewel()
	queue_free()


func spawn_jewel():
	var jewel = jewel_scn.instance()
	jewel.global_position = global_position
	get_parent().add_child(jewel)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		attacking = true
		anim_player.play("attack")
		attack_timer.start()


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		attacking = false
		attack_timer.stop()


func _on_AttackTimer_timeout():
	if attacking:
		anim_player.play("attack")
		attack_timer.start()
