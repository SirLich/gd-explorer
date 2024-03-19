@tool
extends PreviewBase

@export var text_field : TextEdit

func on_file_selected(path : FilePath):
	if path.suffix == "txt":
		text_field.text = FileAccess.open(path.get_global(),FileAccess.READ).get_as_text()
		visible = true
	else:
		visible = false
