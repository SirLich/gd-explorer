extends MarginContainer

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	Bus.file_selected.connect(on_file_selected)

func on_file_selected(path : FilePath):
	if path.is_image():
		set_image(path)
	
	
func set_image(path : FilePath):
	var image : Image = Image.load_from_file(path.get_global())
	texture_rect.texture = ImageTexture.create_from_image(image)
