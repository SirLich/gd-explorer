extends MarginContainer

@export var tiled_image_preview : TextureRect
@export var single_image_preview : TextureRect

func _ready() -> void:
	Bus.file_selected.connect(on_file_selected)

func on_file_selected(path : FilePath):
	if path.is_image():
		var image = Image.load_from_file(path.get_global())
		tiled_image_preview.configure(image)
		single_image_preview.configure(image)

func _on_tile_button_toggled(toggled_on: bool) -> void:
	tiled_image_preview.visible = toggled_on
	single_image_preview.visible = !toggled_on

var FILTERING_INDEX_MAP = [
	CanvasItem.TEXTURE_FILTER_NEAREST,
	CanvasItem.TEXTURE_FILTER_LINEAR,
	CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS,
	CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS,
	CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC,
	CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
]
func _on_option_button_item_selected(index: int) -> void:
	tiled_image_preview.texture_filter = FILTERING_INDEX_MAP[index]
	single_image_preview.texture_filter = FILTERING_INDEX_MAP[index]
