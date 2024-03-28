@tool
extends MarginContainer

@export var font_container : Control
@export var color_button : ColorPickerButton
@export var background_image : TextureRect

func _ready() -> void:
	color_changed(color_button.color)
	color_button.color_changed.connect(color_changed)
	
func color_changed(color):
	background_image.self_modulate = color
	
func _on_file_tree_file_selected(filepath: FilePath) -> void:
	if filepath.is_font():
		font_container.theme.default_font = load(filepath.get_local())
		visible = true
	else:
		visible = false


func _on_file_tree_resource_file_selected(resource: Resource) -> void:
	print("OK HERE")
	if resource is Font:
		visible = true
		font_container.theme.default_font = resource
