extends MarginContainer

@export var texture_rect : TextureRect

func _ready() -> void:
	Bus.file_selected.connect(on_file_selected)

func on_file_selected(path : FilePath):
	if path.is_image():
		set_image(path)
	
	
func set_image(path : FilePath):
	var image : Image = Image.load_from_file(path.get_global())
	texture_rect.configure(image)


func _on_tile_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		texture_rect.stretch_mode = TextureRect.STRETCH_TILE
	else:
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
