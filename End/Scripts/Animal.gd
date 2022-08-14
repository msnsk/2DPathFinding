extends KinematicBody2D

var speed = 30
var target: KinematicBody2D

onready var sprite = $Sprite
onready var nav_agent = $NavigationAgent2D


func _ready():
	nav_agent.set_target_location(global_position)


func _physics_process(_delta):
	if not nav_agent.is_navigation_finished():
		var current_pos = global_position
		var next_loc = nav_agent.get_next_location()
		var velocity = current_pos.direction_to(next_loc) * speed
		nav_agent.set_velocity(velocity)
		sprite.flip_h = target.global_position.x < global_position.x


func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	move_and_slide(safe_velocity)


func _on_PathTimer_timeout():
	nav_agent.set_target_location(target.global_position)
