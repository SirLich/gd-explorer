@tool
extends MarginContainer
class_name GDEPreview

@onready var cache : GDECache = %Data.cache
@onready var file_tree : GDETree = %FileTree

func _ready() -> void:
	file_tree.resource_file_selected.connect(_handle_file)

func _handle_file(filepath: FilePath, item: TreeItem):
	var resource = cache.get_resource(filepath)
	if can_handle_file(resource):
		handle_file(resource, filepath, item)
		visible = true
	else:
		visible = false
	
# Implement These!
func handle_file(resource: Resource, filepath: FilePath, item: TreeItem):
	pass
func can_handle_file(resource: Resource) -> bool:
	return false
