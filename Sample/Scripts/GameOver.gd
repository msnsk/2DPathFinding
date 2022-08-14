extends Control

onready var jewels_label = $Jewels

func _ready():
	set_process_input(false)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func update_jewels_label(jewel_num):
	jewels_label.text = "jewels: " + str(jewel_num)
	
