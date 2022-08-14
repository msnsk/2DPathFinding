extends Area2D


onready var anim_player = $AnimationPlayer
onready var jewel_sfx = $JewelSFX


func _on_DisappearTimer_timeout():
	anim_player.play("disappear")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "disappear":
		queue_free()


func _on_JewelSFX_finished():
	queue_free()
