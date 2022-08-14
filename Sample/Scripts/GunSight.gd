extends Area2D

onready var anim_player = $AnimationPlayer
	

func _on_GunSight_body_entered(body):
	if body.is_in_group("Enemies"):
		anim_player.play("in_sight")


func _on_GunSight_body_exited(body):
	if body.is_in_group("Enemies"):
		anim_player.play_backwards("in_sight")
