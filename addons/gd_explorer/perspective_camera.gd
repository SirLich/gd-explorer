@tool
extends Camera3D

@export var center : Node3D

var is_focused = false

var yaw_movement_speed = 0.5
var pitch_movement_speed = 0.5
var is_moving = false
var zoom_radius = 2
var scroll_amount = 0.1
var last_position : Vector2
var yaw = 0
var pitch = 0 

func _input(event: InputEvent) -> void:
	if is_focused:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP :
				zoom_radius = zoom_radius * (1 - scroll_amount)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_radius = zoom_radius * (1 + scroll_amount)
			if event.button_index == MOUSE_BUTTON_MIDDLE && event.is_pressed():
				is_moving = true
				last_position = get_viewport().get_mouse_position()
			if event.button_index == MOUSE_BUTTON_MIDDLE && event.is_released():
				is_moving = false

	
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


func _on_model_preview_model_preview_focused(_is_focused: bool) -> void:
	is_focused = _is_focused
