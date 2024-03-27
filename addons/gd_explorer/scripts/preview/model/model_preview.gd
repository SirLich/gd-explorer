@tool
extends MarginContainer

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
	camera.current = false
	camera.current = true
	for n in scene_root.get_children():
		scene_root.remove_child(n)
		n.queue_free()
	
	scene_root.add_child(load(path.get_local()).instantiate())

		
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

