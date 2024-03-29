@tool
extends Resource
class_name GDECache

@export var index_map = {}
@export var resources : Array[Resource]
@export var thumbnail_index_map = {}
@export var thumbnails : Array[Texture]

@export var _project_root : String
signal root_changed(filepath: FilePath)
signal resource_saved(resource: Resource)

func clear():
	index_map = {}
	resources = []
	thumbnail_index_map = {}
	thumbnails = []

func has_thumbnail(path: FilePath) -> bool:
	if path == null:
		return false
	return thumbnail_index_map.has(path.get_local())
	
func get_thumbnail(path : FilePath) -> Texture:
	return thumbnails[index_map[path.get_local()]]

func save_thumbnail(path : FilePath, thumb : Texture) -> Resource:
	thumbnail_index_map[path.get_local()] = thumbnails.size()
	thumbnails.append(thumb)
	return thumb

func has_resource(path : FilePath) -> bool:
	if path == null:
		return false
		
	var path_string = path.get_local()
	if index_map.has(path_string):
		var index = index_map.get(path_string)
		if resources.size() >= index:
			var resource = resources[index]
			if resource != null:
				return true
	return false
	
func get_resource(path : FilePath) -> Resource:
	return resources[index_map[path.get_local()]]

func save_resource(path : FilePath, resource : Resource) -> Resource:
	index_map[path.get_local()] = resources.size()
	resources.append(resource)
	return resource


func get_root_string() -> String:
	return _project_root
	
func get_root() -> FilePath:
	return FilePath.from_string(_project_root)

# Variant: Takes either filepath or string
func set_root(filepath):
	if filepath is String:
		filepath = FilePath.from_string(filepath)
		
	_project_root = filepath.get_local()
	root_changed.emit(filepath)
	
func print():
	print("Index Map:")
	for key in index_map.keys():
		print("key: %s, index: %d" % [key, index_map[key]])
	
	print("Resources:")
	var i = 0
	for resource in resources:
		print("%d: %s" % [i, str(resource)])
		i += 1
	
	

