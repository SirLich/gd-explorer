@tool
extends PreviewBase

signal model_preview_focused(is_focused : bool)
	
@export var scene_root : Node3D
@export var camera : Camera3D
@export var envs : Array[Environment]
@export var viewport : SubViewport
@export var test_cube_scene : PackedScene

var is_focused = false

func _on_file_tree_file_selected(filepath: FilePath) -> void:
	if filepath.suffix == "gltf" or filepath.suffix == "glb":
		set_model(filepath)
		visible = true
	else:
		visible = false

func get_space(depth):
	var out = ""
	for i in depth:
		out += "-"
	return out
	
func print_rec(node : Node, depth):
	print(get_space(depth) + node.to_string())
	for child in node.get_children(true):
		print_rec(child, depth + 1)

func replace_recursive(node : Node):
	if node is ImporterMeshInstance3D:
		var mesh = MeshInstance3D.new()
		mesh.set_mesh(node.mesh)
		node.replace_by(mesh)
		
	for child in node.get_children(true):
		replace_recursive(child)
	
	
func set_model(path : FilePath):
	viewport.debug_draw
	camera.current = false
	camera.current = true
	for n in scene_root.get_children():
		scene_root.remove_child(n)
		n.queue_free()
	
	#scene_root.add_child(test_cube_scene.instantiate())
	var gltf_document_load = GLTFDocument.new()
	gltf_document_load.register_gltf_document_extension(GLTFDocumentExtensionConvertImporterMesh.new(), true)
	var gltf_state_load = GLTFState.new()
	#GLTFDocumentExtensionConvertImporterMesh
	#gltf_state_load.add_used_extension("convert_importer_mesh", true)
	
	var error = gltf_document_load.append_from_file(path.get_global(), gltf_state_load)
	if error == OK:
		var gltf_scene_root_node = gltf_document_load.generate_scene(gltf_state_load)
		replace_recursive(gltf_scene_root_node)
		GLTFDocumentExtensionConvertImporterMesh
		print_rec(gltf_scene_root_node, 0)
		scene_root.add_child(gltf_scene_root_node)
		gltf_scene_root_node.owner = scene_root
	else:
		push_error("Couldn't load glTF scene (error code: %s)." % error_string(error))

		
func _on_orthographic_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		camera.set_orthogonal(2, 0.05, 4000)
	else:
		camera.set_perspective(75, 0.05, 4000)

func _on_option_button_item_selected(index: int) -> void:
	camera.environment = envs[index]

func _on_sub_viewport_container_mouse_entered() -> void:
	is_focused = true
	model_preview_focused.emit(is_focused)
func _on_sub_viewport_container_mouse_exited() -> void:
	is_focused = false
	model_preview_focused.emit(is_focused)

