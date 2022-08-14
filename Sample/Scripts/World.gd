extends Node2D

const enemy_scn = preload("res://Scenes/Enemy.tscn")

var jewel: int = 0

onready var tilemap = $TileMap
onready var line = $Line2D
onready var player = $Player
onready var gun_sight = $GunSight
onready var enemies = $Enemies
onready var spawn_timer = $SpawnTimer
onready var hud = $UILayer/HUD
onready var gameover = $UILayer/GameOver


func _ready():
	randomize()
	gameover.hide()
	hud.update_life(player.life)
	hud.update_bullets(player.bullets)
	hud.update_jewel(jewel)
	player.connect("player_hit", self, "_on_Player_player_hit")
	player.connect("bullet_shot", self, "_on_Player_bullet_shot")
	player.connect("jewel_picked", self, "_on_Player_jewel_picked")
	player.connect("killed", self, "_on_Player_killed")
	spawn_enemy()


func _process(_delta):
	gun_sight.position = get_global_mouse_position()


func _on_SpawnTimer_timeout():
	spawn_enemy()


func spawn_enemy():
	var cells = tilemap.get_used_cells_by_id(9)
	var spawn_tile = cells[randi() % cells.size()]
	#print("spawn tile: ", spawn_tile)
	var spawn_pos = tilemap.map_to_world(spawn_tile, true) + Vector2(8, 8)
	#print("spawn position: ", spawn_pos)
	var enemy = enemy_scn.instance()
	enemy.position = spawn_pos
	enemy.player = player
	enemies.add_child(enemy)


func _on_Player_player_hit():
	hud.update_life(player.life)


func _on_Player_bullet_shot():
	hud.update_bullets(player.bullets)


func _on_Player_jewel_picked():
	jewel += 1
	hud.update_jewel(jewel)


func _on_Player_killed():
	gameover.update_jewels_label(jewel)
	gameover.show()
	gameover.set_process_input(true)
