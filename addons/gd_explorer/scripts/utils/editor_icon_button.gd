@tool
extends Button

@export var icon_name : String

func _ready() -> void:
	if Engine.is_editor_hint():
		icon = GDEUtils.get_icon(icon_name)
