@tool
extends MarginContainer

signal project_root_set(path : FilePath)

@export var file_dialog : FileDialog

var default_root = "C:\\liam\\assets\\food"

func _ready() -> void:
	set_project_root(default_root)

func _on_file_dialog_dir_selected(dir: String) -> void:
	set_project_root(dir)
	
func _on_button_pressed() -> void:
	file_dialog.popup_centered()

func set_project_root(dir):
	project_root_set.emit(FilePath.from_string(dir))




