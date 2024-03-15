extends TextureRect

var SCALE_FACTOR = 0.1


func configure(tex : Image):
	texture = ImageTexture.create_from_image(tex)
	pivot_offset = size/2
	
func _input(event: InputEvent) -> void:
	if event.is_action("scroll_up"):
		scale = scale * (1 + SCALE_FACTOR)
	elif event.is_action("scroll_down"):
		scale = scale * (1 - SCALE_FACTOR)
	pivot_offset = size/2
