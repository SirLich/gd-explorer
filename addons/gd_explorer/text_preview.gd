@tool
extends PreviewBase

@export var text_field : TextEdit

func _on_file_tree_file_selected(filepath: FilePath) -> void:
	if filepath.suffix == "txt":
		text_field.text = FileAccess.open(filepath.get_global(),FileAccess.READ).get_as_text()
		visible = true
	else:
		visible = false
