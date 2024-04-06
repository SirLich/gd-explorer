extends Node

@export var cache : GDECache

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveBundledResource(cache, "res://addons/gd_explorer/cache/cache.res")
		get_tree().quit()

static func saveBundledResource(resource, path) -> Error:
	var e := ResourceSaver.save(
		resource, path, ResourceSaver.FLAG_BUNDLE_RESOURCES
		)
	if !e:
		e = fixBundledResource(path)
	return e

# change class_name scripts to just extend the given class_name
# avoids name collisions upon load
# scripts without class_name should remain untouched
static func fixBundledResource(file_path) -> Error:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if !file:
		return ERR_CANT_OPEN
	
	var lines := file.get_as_text().split("\n")
	file.close()
	
	var skip := false
	var current_class := ""
	var match_class = RegEx.create_from_string("class_name (\\w+)")
	var skipped_lines: PackedStringArray = []
	
	file = FileAccess.open(file_path, FileAccess.WRITE)
	if !file:
		return ERR_CANT_OPEN
	
	for line in lines:
		if line.begins_with("script/source"):
			skip = true
		if skip:
			skipped_lines.append(line)
			var class_match = match_class.search(line)
			if class_match: current_class = class_match.get_string(1)
			if line == '"':
				skip = false
				if current_class != "":
					file.store_line('script/source = "extends %s' % current_class)
					file.store_line('"')
					current_class = ""
				else:
					for skipped in skipped_lines:
						file.store_line(skipped)
				skipped_lines = []
		else:
			file.store_line(line)
	file.close()
	return OK
	
