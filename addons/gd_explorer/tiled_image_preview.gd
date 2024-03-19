@tool
extends ImagePreview
class_name TiledImagePreview

func _input(event: InputEvent) -> void:
	if event.is_action("ui_text_scroll_up"):
		tex_scale = tex_scale * (1 + SCALE_FACTOR)
		set_and_resize_texture()
	elif event.is_action("ui_text_scroll_down"):
		tex_scale = tex_scale * (1 - SCALE_FACTOR)
		set_and_resize_texture()
	pivot_offset = size/2
