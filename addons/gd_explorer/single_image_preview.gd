@tool
extends ImagePreview
class_name SingleImagePreview

func _input(event: InputEvent) -> void:
	if event.is_action("ui_text_scroll_up"):
		scale = scale * (1 + SCALE_FACTOR)
	elif event.is_action("ui_text_scroll_down"):
		scale = scale * (1 - SCALE_FACTOR)
	pivot_offset = size/2
