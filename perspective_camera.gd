extends Camera3D

@export var center : Node3D

var yaw_movement_speed = 0.5
var pitch_movement_speed = 0.5
var is_moving = false
var zoom_radius = 100
var scroll_amount = 0.1
var last_position : Vector2
var yaw = 0
var pitch = 0 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_3d"):
		is_moving = true
		last_position = get_viewport().get_mouse_position()
	if event.is_action_released("move_3d"):
		is_moving = false
	if event.is_action("scroll_up"):
		zoom_radius = zoom_radius * (1 - scroll_amount)
	if event.is_action("scroll_down"):
		zoom_radius = zoom_radius * (1 + scroll_amount)
		
func _process(delta: float) -> void:
	if is_moving:
		var mouse_vector = get_viewport().get_mouse_position() - last_position
		last_position = get_viewport().get_mouse_position()
		yaw += mouse_vector.x * yaw_movement_speed * delta
		pitch += mouse_vector.y * pitch_movement_speed * delta
		
		yaw = fmod(yaw, TAU)
		pitch = fmod(pitch, TAU)
		
		var temp = center.global_position
		temp.z += 1
		
		temp = center.global_position + (temp - center.global_position).rotated(Vector3.UP, yaw)
		temp = center.global_position + (temp - center.global_position).rotated(Vector3.RIGHT, pitch)
		
		global_position = temp
		
	global_position = center.global_position.direction_to(global_position) * zoom_radius
	look_at(center.global_position)
