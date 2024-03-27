@tool
extends ImagePreview
class_name SingleImagePreview

@export var image_preview : Node

func _input(event: InputEvent) -> void:
	if image_preview.is_active:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				scale = scale * (1 + SCALE_FACTOR)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				scale = scale * (1 - SCALE_FACTOR)
			pivot_offset = size/2
