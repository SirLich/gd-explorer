@tool
extends GDEPreview

signal model_preview_focused(is_focused : bool)
	
@export var scene_root : Node3D
@export var camera : Camera3D
@export var envs : Array[Environment]
@export var viewport : SubViewport
@export var test_cube_scene : PackedScene

var is_focused = false

func _ready() -> void:
	super._ready()

func can_handle_file(resource: Resource) -> bool:
	return resource is PackedScene
	
func handle_file(resource: Resource, filepath: FilePath, item: TreeItem):
	camera.current = false
	camera.current = true
	for n in scene_root.get_children():
		scene_root.remove_child(n)
		n.queue_free()
	scene_root.add_child(resource.instantiate())
		
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

