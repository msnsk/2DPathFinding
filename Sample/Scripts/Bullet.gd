extends Area2D

export var speed = 150
onready var gun_shot_sfx = $GunShotSFX


func _ready():
	gun_shot_sfx.play()


func _physics_process(delta): 
	position += transform.x * speed * delta


func _on_Bullet_body_entered(body):
#	print("Bullet hit ", body)
	if body.is_in_group("Enemies"):
		body.life -= 1
		if body.life > 0:
			body.anim_player.play("hit")
		else:
			body.set_process(false)
			body.get_node("Sprite").hide()
			body.get_node("CPUParticles2D").emitting = true
			if not body.get_node("KilledSFX").is_playing():
				body.get_node("KilledSFX").play()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
#	print("Bullet exited from screen")
	queue_free()
