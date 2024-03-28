@tool
extends MarginContainer

@export var font_container : Control
@export var color_button : ColorPickerButton
@export var background_image : TextureRect
@export var cache : GDECache

func _ready() -> void:
	color_changed(color_button.color)
	color_button.color_changed.connect(color_changed)
	
func color_changed(color):
	background_image.self_modulate = color

func _on_file_tree_resource_file_selected(filepath : FilePath) -> void:
	var resource = cache.get_resource(filepath)
	if resource is Font:
		visible = true
		font_container.theme.default_font = resource
	else:
		visible = false
