extends MarginContainer

@export var mesh_instance : MeshInstance3D

func _ready() -> void:
	Bus.file_selected.connect(on_file_selected)

func on_file_selected(path : FilePath):
	if path.suffix == "gltf" or path.suffix == "glb":
		set_model(path)
		
func set_model(path : FilePath):
	var gltf_document_load = GLTFDocument.new()
	var gltf_state_load = GLTFState.new()
	var error = gltf_document_load.append_from_file(path.get_global(), gltf_state_load)
	if error == OK:
		var gltf_scene_root_node = gltf_document_load.generate_scene(gltf_state_load)
		mesh_instance.add_child(gltf_scene_root_node)
	else:
		push_error("Couldn't load glTF scene (error code: %s)." % error_string(error))

