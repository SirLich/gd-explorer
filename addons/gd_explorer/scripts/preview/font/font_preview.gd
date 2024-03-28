@tool
extends GDEPreview

@export var font_container : Control
@export var color_button : ColorPickerButton
@export var background_image : TextureRect

func _ready() -> void:
	super._ready()
	color_changed(color_button.color)
	color_button.color_changed.connect(color_changed)
	
func can_handle_file(resource: Resource) -> bool:
	return resource is Font

func handle_file(resource, filepath, item):
	font_container.theme.default_font = resource
	

	
func color_changed(color):
	background_image.self_modulate = color

