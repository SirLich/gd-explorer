@tool
extends MarginContainer

signal on_input(event : InputEvent)

func _input(event: InputEvent) -> void:
	on_input.emit(event)
