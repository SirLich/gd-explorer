@tool
extends Resource
class_name GDECache

@export var index_map = {}
@export var resources : Array[Resource]

func clear():
	index_map = {}
	resources = []
	
func has_resource(path : FilePath) -> bool:
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
	
func print():
	print("Index Map:")
	for key in index_map.keys():
		print("key: %s, index: %d" % [key, index_map[key]])
	
	print("Resources:")
	var i = 0
	for resource in resources:
		print("%d: %s" % [i, str(resource)])
		i += 1
	
	

