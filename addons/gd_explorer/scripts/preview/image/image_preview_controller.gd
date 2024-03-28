@tool
extends MarginContainer

@export var tiled_image_preview : TextureRect
@export var single_image_preview : TextureRect
@export var background_image : TextureRect
@export var data_label : Label
@export var backgrounds : Array[Texture2D]
@export var background_color_button : ColorPickerButton
@export var cache : GDECache
@export var file_tree : Tree

var is_active = false

func _ready() -> void:
	background_image.self_modulate = background_color_button.color
	file_tree.resource_file_selected.connect(_on_file_tree_resource_file_selected)

func _on_file_tree_resource_file_selected(filepath: FilePath, item : TreeItem) -> void:
	var resource = cache.get_resource(filepath)
	if resource is Texture:
		# Update icon visuals
		item.set_icon(0, resource)
		item.set_icon_modulate(0, Color.WHITE)
		
		# The rest
		var image = resource.get_image()
		tiled_image_preview.configure(image)
		data_label.text = str(image.get_width()) + "x" + str(image.get_height())
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


func _on_margin_container_mouse_entered() -> void:
	is_active = true
func _on_margin_container_mouse_exited() -> void:
	is_active = false


func _on_modulate_button_color_changed(color: Color) -> void:
	background_image.self_modulate = color
