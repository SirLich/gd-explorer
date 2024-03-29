@tool
extends MarginContainer

@export var file_dialog : FileDialog
@export var select_root_button : Button
@export var root_line_edit : LineEdit
@export var clear_cache_button : Button
@export var cache : GDECache

func _ready() -> void:
	set_project_root(cache.get_root_string())
	
func _on_file_dialog_dir_selected(dir: String) -> void:
	set_project_root(dir)
	
func _on_button_pressed() -> void:
	file_dialog.popup_centered()

func set_project_root(dir):
	cache.set_root(dir)
	root_line_edit.text = dir

func _on_line_edit_text_submitted(new_text: String) -> void:
	if DirAccess.dir_exists_absolute(new_text):
		set_project_root(new_text)
	else:
		root_line_edit.text = cache.get_root().get_global()
