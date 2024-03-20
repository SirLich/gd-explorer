@tool
extends PreviewBase

signal model_preview_focused(is_focused : bool)
	
@export var scene_root : Node3D
@export var camera : Camera3D
@export var envs : Array[Environment]

var is_focused = false

func on_file_selected(path : FilePath):
	if path.suffix == "gltf" or path.suffix == "glb":
		set_model(path)
		visible = true
	else:
		visible = false
		
func set_model(path : FilePath):
	for n in scene_root.get_children():
		scene_root.remove_child(n)
		n.queue_free()
		
	var gltf_document_load = GLTFDocument.new()
	var gltf_state_load = GLTFState.new()
	var error = gltf_document_load.append_from_file(path.get_global(), gltf_state_load)
	if error == OK:
		var gltf_scene_root_node = gltf_document_load.generate_scene(gltf_state_load)
		scene_root.add_child(gltf_scene_root_node)
	else:
		push_error("Couldn't load glTF scene (error code: %s)." % error_string(error))

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		pass
		
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
