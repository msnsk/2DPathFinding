extends Control


onready var jewel_num = $JewelContainer/JewelNum
onready var bullet_container = $BulletContainer
onready var life_container = $LifeContainer


func update_jewel(jewels: int):
	jewel_num.text = str(jewels)


func update_bullets(bullets_remaining: int):
	for i in bullet_container.get_child_count():
		bullet_container.get_child(i).visible = bullets_remaining > i


func update_life(life_remaining: int):
	for i in life_container.get_child_count():
		life_container.get_child(i).visible = life_remaining > i
