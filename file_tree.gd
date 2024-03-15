extends Tree

@export var folder_icon : Texture2D
@export var file_icon : Texture2D
@export var error_icon : Texture2D

var project_root : FilePath
var current_root : FilePath

func _ready() -> void:
	Bus.project_root_set.connect(_on_project_root_set)
	
func _on_project_root_set(project_root):
	project_root = project_root
	current_root = project_root
	print("func _on_project_root_set(project_root):")
	print(current_root.get_local())
	build_tree()

func build_tree():
	clear()
	var root = create_item()
	for child in current_root.get_children():
		print("func build_tree")
		print(child.get_local())
		var item = root.create_child()
		item.set_text(0, child.name)
		if child.file_exists():
			item.set_icon(0, file_icon)
		elif child.directory_exists():
			item.set_icon(0, folder_icon)
		else:
			item.set_icon(0, error_icon)
		item.set_icon_max_width(0, 24)
		item.set_metadata(0, child)
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_item_activated() -> void:
	var selected = get_selected()
	var filepath : FilePath = selected.get_metadata(0)
	if filepath.is_directory():
		current_root = filepath
		build_tree()
	else:
		Bus.file_selected.emit(filepath)


func _on_up_button_pressed() -> void:
	print(current_root)
	current_root = current_root.parent
	print(current_root)
	build_tree()
