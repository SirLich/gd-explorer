@tool
extends PreviewBase

@export var tiled_image_preview : TextureRect
@export var single_image_preview : TextureRect
@export var background_image : TextureRect

@export var backgrounds : Array[Texture2D]

func on_file_selected(path : FilePath):
	if path.is_image():
		var image = Image.load_from_file(path.get_global())
		tiled_image_preview.configure(image)
		single_image_preview.configure(image)
		visible = true
	else:
		visible = false

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


func _on_color_picker_button_color_changed(color: Color) -> void:
	tiled_image_preview.modulate = color
	single_image_preview.modulate = color


func _on_background_option_button_item_selected(index: int) -> void:
	background_image.texture = backgrounds[index]