@tool
extends PreviewBase

@export var text_field : TextEdit
@export var copy_button : Button

func _ready() -> void:
	copy_button.icon = GDEUtils.get_icon("ActionCopy")
	copy_button.pressed.connect(on_copy)
	
func on_copy():
	DisplayServer.clipboard_set(text_field.text)
	
func _on_file_tree_file_selected(filepath: FilePath) -> void:
	print("WOW")
	if filepath.suffix == "txt":
		text_field.text = FileAccess.open(filepath.get_global(),FileAccess.READ).get_as_text()
		visible = true
	else:
		visible = false
