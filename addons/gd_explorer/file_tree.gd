@tool
extends Tree

@export var folder_icon : Texture2D
@export var file_icon : Texture2D
@export var error_icon : Texture2D
@export var collapse_icon : Texture2D

signal file_selected(filepath : FilePath)

var root : TreeItem
var _project_root : FilePath
var current_root : FilePath

func _ready() -> void:
	set_column_expand(0, true)
	set_column_expand(1, false)
	
func _on_folder_view_project_root_set(path: FilePath) -> void:
	_project_root = path
	current_root = _project_root._duplicate()
	
	root = create_item()
	root.set_text(0, "Project")
	build_tree_recursive(root, current_root)

var supress_action

func force_build_recusrive(item : TreeItem):
	var filepath : FilePath = item.get_metadata(0)
	item.set_collapsed_recursive(false)
	item.set_collapsed_recursive(true)
	
func build_tree_recursive(item : TreeItem, path : FilePath):
	supress_action = true

	for child_path in path.get_children():
		
		if not child_path.is_known_type() and not child_path.is_directory():
			continue
			
		var child_item = item.create_child()
		child_item.set_text(0, child_path.name)
		if child_path.file_exists():
			child_item.set_icon(0, file_icon)
			
		elif child_path.directory_exists():
			child_item.set_icon(0, folder_icon)
				
			var icon = collapse_icon.duplicate()
			var image : Image = icon.get_image()
			image.resize(24, 24, Image.INTERPOLATE_TRILINEAR)
			icon = ImageTexture.create_from_image(image)
			
			child_item.add_button(1, icon, -1, false, "Press to build asset cache for this folder.")
			child_item.set_icon_max_width(1, 24)
			
			var dummy = child_item.create_child()
			dummy.set_meta("dummy", true)
			dummy.set_text(0, "...")
			child_item.collapsed = true
		else:
			child_item.set_icon(0, error_icon)
		child_item.set_icon_max_width(0, 24)
		child_item.set_metadata(0, child_path)
		
	supress_action = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_item_activated() -> void:
	var selected = get_selected()
	item_selected(selected)
	
func item_selected(item : TreeItem):
	var filepath : FilePath = item.get_metadata(0)
	if filepath.is_directory():
		current_root = filepath
	else:
		f_file_selected(filepath)

func f_file_selected(filepath : FilePath):
	modulate = Color.RED 
	var new_path = filepath.copy_to_cache()
	EditorInterface.get_resource_filesystem().scan_sources()
	EditorInterface.get_resource_filesystem().scan()
	
	if not ResourceLoader.exists(new_path.get_local()):
		await EditorInterface.get_resource_filesystem().filesystem_changed
	
	modulate = Color.WHITE 
	file_selected.emit(new_path)

func _on_up_button_pressed() -> void:
	current_root = current_root.parent
	#build_tree()


func _on_root_button_pressed() -> void:
	current_root = _project_root._duplicate()
	#build_tree()

func is_dummy_folder(item : TreeItem):
	if item.get_child_count() > 0:
		if item.get_child(0).has_meta("dummy"):
			return true
	return false
	
func set_visibility_recursive(text : String, root : TreeItem):
	var vis = false
	for item in root.get_children():
		if item.get_child_count() > 0 && not is_dummy_folder(item):
			var should_be_visible = set_visibility_recursive(text, item)
			item.visible = should_be_visible
			if should_be_visible:
				item.collapsed = false
				vis = true
		else:
			var should_be_visible = text == "" or item.get_text(0).to_lower().contains(text)
			item.visible = should_be_visible
			if should_be_visible:
				vis = true
	return vis
		

func _on_line_edit_text_changed(new_text: String) -> void:
	set_visibility_recursive(new_text.to_lower(), root)

	

func get_next_vis(root_item : TreeItem):
	for item in root_item.get_children():
		if item.visible:
			return item
	return null

func _input(event: InputEvent) -> void:
	# TODO
	pass
	#if event.is_action_released("up_one_folder"):
		#_on_up_button_pressed()
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	var next_valid = get_next_vis(root)
	if next_valid:
		item_selected(next_valid)

func _on_color_picker_button_color_changed(color: Color) -> void:
	pass # Replace with function body.

func _on_item_collapsed(item: TreeItem) -> void:
	if supress_action:
		return
		
	var is_open_action = item.collapsed
	if item.get_child_count() > 0:
		if item.get_child(0).has_meta("dummy"):
			item.get_child(0).free()
			build_tree_recursive(item, item.get_metadata(0))

func _on_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) -> void:
	force_build_recusrive(item)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
func _drop_data(at_position: Vector2, data: Variant) -> void:
	print(data)
func _get_drag_data(at_position: Vector2) -> Variant:
	var item : TreeItem = get_item_at_position(at_position)
	var filepath : FilePath = item.get_metadata(0).get_cache_path()
	print(filepath.get_local())
	
	if filepath.is_directory():
		return null
	else:
		return { "type": "files", "files": [filepath.get_local()]}
		
	
