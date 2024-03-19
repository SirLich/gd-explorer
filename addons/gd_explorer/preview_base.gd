@tool
extends MarginContainer
class_name PreviewBase

func _ready() -> void:
	Bus.file_selected.connect(on_file_selected)

func on_file_selected(path : FilePath):
	pass
