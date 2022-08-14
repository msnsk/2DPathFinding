extends KinematicBody2D

signal player_hit
signal bullet_shot
signal jewel_picked
signal killed

const bullet_scn = preload("res://Scenes/Bullet.tscn")

export (int) var life = 5
export (float) var speed = 40.0
export (int) var max_bullets = 12
var bullets = max_bullets

onready var line = get_node("../Line2D")
onready var body_sprite = $BodySprite
onready var gun = $GunSprite
onready var muzzle = $GunSprite/Mussle
onready var nav_agent = $NavigationAgent2D
onready var anim_player = $AnimationPlayer
onready var hit_sfx = $HitSFX
onready var killed_sfx = $KilledSFX
onready var reload_sfx = $ReloadSFX


func _ready():
	nav_agent.set_target_location(global_position)
	nav_agent.get_next_location()


func _physics_process(delta):
	if not nav_agent.is_navigation_finished():
		var target = nav_agent.get_next_location()
		var current_pos = global_position
		var velocity = current_pos.direction_to(target) * speed
		nav_agent.set_velocity(velocity)
		anim_player.play("move")
	else:
		if anim_player.current_animation == "move":
			anim_player.stop()
			body_sprite.rotation = 0
	point_gun()
	get_input()


func point_gun():
	if anim_player.current_animation == "reload":
		return
	var mouse_pos = get_global_mouse_position()
	gun.position = position.direction_to(mouse_pos) * 16
	gun.rotation = gun.position.angle()
	if gun.rotation_degrees > -90 and gun.rotation_degrees <= 90:
		if gun.flip_v:
			gun.flip_v = false
			muzzle.position.y *= -1
	else:
		if not gun.flip_v:
			gun.flip_v = true
			muzzle.position.y *= -1


func get_input():
	if Input.is_action_pressed("move_to"):
		find_path()
	if Input.is_action_just_pressed("shoot"):
		if bullets > 0:
			shoot()
		else:
			reload()
		emit_signal("bullet_shot")


func find_path():
	nav_agent.set_target_location(get_global_mouse_position())
	nav_agent.get_next_location()
	line.points = nav_agent.get_nav_path()


func shoot():
	bullets -= 1
	var bullet = bullet_scn.instance()
	bullet.global_transform = muzzle.global_transform
	get_parent().add_child(bullet)


func reload():
	gun.flip_v = false
	anim_player.play("reload")
	reload_sfx.play()
	bullets = max_bullets


func _on_HitBox_body_entered(body):
	if body.is_in_group("Enemies"):
		if life > 0:
			life -= 1
			emit_signal("player_hit")
			anim_player.play("hit")
			hit_sfx.play()
			if life == 0:
				set_physics_process(false)
				set_process_input(false)
				anim_player.play("die")
				killed_sfx.play()


func _on_KilledSFX_finished():
	emit_signal("killed")


func _on_HitBox_area_entered(area):
	if area.is_in_group("Jewels"):
		area.jewel_sfx.play()
		emit_signal("jewel_picked")


func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	move_and_slide(safe_velocity)


func _on_NavigationAgent2D_target_reached():
	line.points = nav_agent.get_nav_path()


func _on_NavigationAgent2D_navigation_finished():
	line.points.resize(0)

