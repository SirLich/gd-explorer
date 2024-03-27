extends Object
class_name GDEUtils

static func get_icon(name: String) -> Texture2D:
	return EditorInterface.get_base_control().get_theme_icon(name, "EditorIcons")
