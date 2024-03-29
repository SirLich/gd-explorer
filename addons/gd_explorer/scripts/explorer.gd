@tool
extends MarginContainer

@export var cache : GDECache

signal on_input(event : InputEvent)

func _input(event: InputEvent) -> void:
	on_input.emit(event)

func on_resource_saved(resource : Resource):
	cache.resource_saved.emit(resource)
