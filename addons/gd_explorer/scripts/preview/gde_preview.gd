@tool
extends MarginContainer
class_name GDEPreview

@export var cache : GDECache
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
	
func handle_file(resource: Resource, filepath: FilePath, item: TreeItem):
	print("'handle file' should always be implemented!")
	
func can_handle_file(resource: Resource) -> bool:
	print("'can_handle_file' not implemented")
	return false
