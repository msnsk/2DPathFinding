extends KinematicBody2D

export (float) var speed = 40

onready var line: Line2D = get_node("../Line2D")
onready var nav_agent = $NavigationAgent2D


func _ready():
	nav_agent.set_target_location(global_position)


func _physics_process(delta):
	if not nav_agent.is_navigation_finished():
		var next_loc = nav_agent.get_next_location()
		var current_pos = global_position
		var velocity = current_pos.direction_to(next_loc) * speed
		nav_agent.set_velocity(velocity)
	if Input.is_action_pressed("move_to"):
		find_path()


func find_path():
	nav_agent.set_target_location(get_global_mouse_position())
	nav_agent.get_next_location()
	line.points = nav_agent.get_nav_path()


func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	move_and_slide(safe_velocity)


func _on_NavigationAgent2D_target_reached():
	line.points = nav_agent.get_nav_path()


func _on_NavigationAgent2D_navigation_finished():
	line.points.resize(0)

