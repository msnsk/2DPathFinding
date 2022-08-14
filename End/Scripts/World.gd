extends Node2D

const animal_scn = preload("res://Scenes/Animal.tscn")

export (int) var head_count = 12

onready var tile_map = $TileMap
onready var player = $Player
onready var animals = $Animals


func _ready():
	randomize()
	var cells = tile_map.get_used_cells_by_id(9)
	for i in head_count :
		var random_index = randi() % cells.size()
		var spawn_tile = cells.pop_at(random_index)
		while spawn_tile == null and not cells.empty():
			random_index = randi() % cells.size()
			spawn_tile = cells.pop_at(random_index)
		spawn_animal(spawn_tile)


func spawn_animal(spawn_tile):
	var spawn_pos = tile_map.map_to_world(spawn_tile, true) + Vector2(8, 8)
	var animal = animal_scn.instance()
	animal.position = spawn_pos
	animal.target = player
	animal.get_node("Sprite").frame = randi() % animal.get_node("Sprite").hframes
	animals.add_child(animal)
