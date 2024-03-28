@tool
extends Tree

@onready
var EC_BLUE = Color("#63A3DC")
@onready
var EC_LIGHT_GRAY = Color("#363D4A")
@onready 
var EC_DARK_GRAY = Color("#21262E")

@export var folder_icon : Texture2D
@export var file_icon : Texture2D
@export var error_icon : Texture2D
@export var collapse_icon : Texture2D

@export var cache : GDECache

signal file_selected(filepath : FilePath)
signal resource_file_selected(filepath: FilePath)

var root : TreeItem
var _project_root : FilePath
var current_root : FilePath

func _ready() -> void:
	#EditorInterface.get_resource_filesystem().get_filesystem()
	
	set_column_expand(0, true)
	
func _on_folder_view_project_root_set(path: FilePath) -> void:
	_project_root = path
	current_root = _project_root._duplicate()
	
	clear()
	
	root = create_item()
	root.set_text(0, "Project")
	configure_button_for_item(root)
	build_tree_recursive(root, current_root, true)
	
var supress_action

func configure_button_for_item(item : TreeItem):
	item.add_button(0, GDEUtils.get_icon("EditorCurveHandle"))
	item.set_button_color(0, 0, EC_LIGHT_GRAY)

func set_is_file(item : TreeItem):
	item.set_meta("is_file", true)
func set_is_folder(item : TreeItem):
	item.set_meta("is_file", false)
func is_file(item : TreeItem):
	return item.get_meta("is_file")
func is_folder(item : TreeItem):
	return not is_file(item)
	
func build_tree_recursive(item : TreeItem, path : FilePath, go_on: bool):
	Tracker.push("build_tree_recursive")
	supress_action = true
	
	for dir_path in path.get_dirs():
		# SHARED
		var child_item = item.create_child()
		child_item.set_text(0, dir_path.name)
		
		child_item.set_icon(0, GDEUtils.get_icon("Folder"))
		child_item.set_meta("is_file", false)
		child_item.set_icon_modulate(0, EC_LIGHT_GRAY)
			
		configure_button_for_item(child_item)
		
		if go_on:
			build_tree_recursive(child_item, dir_path, go_on)
		else:
			var dummy = child_item.create_child()
			dummy.set_meta("dummy", true)
			dummy.set_text(0, "...")
			child_item.collapsed = true
		
		# SHARED
		child_item.set_icon_max_width(0, 24)
		child_item.set_metadata(0, dir_path)
	
	for f_path in path.get_filess():
		# SHARED
		var child_item = item.create_child()
		child_item.set_text(0, f_path.name)
		
		child_item.set_icon(0, file_icon)
		child_item.set_meta("is_file", true)
		
		# SHARED
		child_item.set_icon_max_width(0, 24)
		child_item.set_metadata(0, f_path)
		
	supress_action = false
	Tracker.pop("build_tree_recursive")

func _on_item_activated() -> void:
	var selected = get_selected()
	item_selected(selected)
	
func item_selected(item : TreeItem):
	var filepath : FilePath = item.get_metadata(0)
	if filepath.directory_exists():
		current_root = filepath
	else:
		f_file_selected(filepath)

func f_file_selected(filepath : FilePath):
	modulate = Color.RED 
	
	var cache_path = filepath.copy_to_cache()
	if cache_path.is_resource():
		
		if cache.has_resource(cache_path):
			print("Already cached:")
		else: 
			# Wait if loading is required
			if not ResourceLoader.exists(cache_path.get_local()):
				EditorInterface.get_resource_filesystem().scan_sources()
				EditorInterface.get_resource_filesystem().scan()
				await EditorInterface.get_resource_filesystem().filesystem_changed
				
			var new_resource = load(cache_path.get_local())
			cache.save_resource(cache_path, new_resource)
			
			print("Newly cached:")
			
		cache.print()
			
		delete_async(cache_path)
		resource_file_selected.emit(cache_path)
		
	modulate = Color.WHITE 
	#file_selected.emit(new_path)

func delete_async(path : FilePath):
	await get_tree().create_timer(5).timeout
	DirAccess.remove_absolute(path.get_local())
	DirAccess.remove_absolute(path.get_local() + ".import")
	EditorInterface.get_resource_filesystem().scan()
	
func is_dummy_folder(item : TreeItem):
	Tracker.push("is_dummy_folder")
	if item.get_child_count() > 0:
		if item.get_child(0).has_meta("dummy"):
			Tracker.pop("is_dummy_folder")
			return true
	Tracker.pop("is_dummy_folder")
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

func is_fully_searchable(item : TreeItem):
	Tracker.push("is_fully_searchable")
	for child in item.get_children():
		if is_dummy_folder(child):
			Tracker.pop("is_fully_searchable")
			return false
	Tracker.pop("is_fully_searchable")
	return true
	
func _on_item_collapsed(item: TreeItem) -> void:
	if supress_action:
		return
	
	if is_dummy_folder(item):
		item.get_child(0).free()
		build_tree_recursive(item, item.get_metadata(0), false)
	
	if is_fully_searchable(item):
		item.set_icon_modulate(0, EC_BLUE)
	
func _on_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) -> void:
	Tracker.push("_on_button_clicked")
	item.set_collapsed_recursive(false)
	item.set_collapsed_recursive(true)
	Tracker.pop("_on_button_clicked")
	Tracker.do_report()


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	print(data)
	
func _get_drag_data(at_position: Vector2) -> Variant:
	var item : TreeItem = get_item_at_position(at_position)
	var filepath : FilePath = item.get_metadata(0).get_cache_path()
	var path_string = filepath.get_local()
	ResourceSaver.save(cache.get_resource(filepath), path_string)
	
	if filepath.directory_exists():
		return null
	else:
		return { "type": "files", "files": [path_string]}
		#return { "type": "resource", "resource": cache.get_resource(filepath)}

func _on_clear_cache_button_pressed() -> void:
	cache.clear()
