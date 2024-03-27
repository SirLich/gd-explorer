@tool
extends RefCounted
class_name FilePath

var _root : String
var _string_path : String

var ROOT_DELIM : StringName = "://"

static func from_string(string_path : String) -> FilePath:
	return FilePath.new(string_path)

static func contains_any(s: String, opts : PackedStringArray):
	for opt in opts:
		if s.contains(opt):
			return true
	return false
	
func _init(string_path : String) -> void:
	_string_path = string_path
	
var suffix : String : get = _get_suffix
var name : String : get = _get_name
var stem : String : get = _get_stem

func is_cached():
	return get_cache_path().exists()
	
func get_cache_path() -> FilePath:
	return FilePath.from_string("res://addons/gd_explorer/cache/").join(name)
	
func copy_to_cache() -> FilePath:
	var to_file = get_cache_path()
	if not FileAccess.file_exists(to_file.get_global()):
		DirAccess.copy_absolute(get_global(), to_file.get_global())
	return to_file
	
func _has_root() -> bool:
	return _root != ""

func _duplicate() -> FilePath:
	return FilePath.from_string(get_local())
	
## Returns whether this is a directory, and that it exists
func directory_exists() -> bool:
	Tracker.push("directory_exists")
	var ret = DirAccess.dir_exists_absolute(get_local())
	Tracker.pop("directory_exists")
	return ret
	
func join(variadic_path) -> FilePath:
	if file_exists():
		push_warning(".join was called on %s, but it's a file" % get_local())
		return
	var new_fp = _duplicate()
	new_fp._string_path = new_fp._string_path + "/" + variadic_path
	return new_fp
	
## Returns whether this is a file, and that it exists
func file_exists() -> bool:
	return FileAccess.file_exists(get_local())

## Returns all children (direcoties first, then files)
func get_children() -> Array[FilePath]:
	Tracker.push("get_children")
	
	var string_paths : PackedStringArray = []
	string_paths.append_array(get_directories())
	string_paths.append_array(get_files())
	var out : Array[FilePath] = []
	for s in string_paths:
		out.append(FilePath.from_string(_string_path + "/" + s))
	
	Tracker.pop("get_children")
	return out
	
## Returns all the directories that are a direct child of this path
func get_directories() -> PackedStringArray:
	return DirAccess.get_directories_at(get_local())
	
func get_dirs() -> Array[FilePath]:
	var out : Array[FilePath] = []
	for s in DirAccess.get_directories_at(get_local()):
		out.append(FilePath.from_string(_string_path + "/" + s))
	return out
	
func get_filess() -> Array[FilePath]:
	var out : Array[FilePath] = []
	for s in DirAccess.get_files_at(get_local()):
		out.append(FilePath.from_string(_string_path + "/" + s))
	return out

## Returns all the files that are a direct child of this path
func get_files() -> PackedStringArray:
	return DirAccess.get_files_at(get_local())

## Returns whether this path appears to be a valid file or directory
func exists():
	return file_exists() or directory_exists()

## Returns whether the path is scoped to the user:// directory.
func is_user_path():
	return _root == "user"

func is_text() -> bool:
	return contains_any(suffix, [
		"txt", "md"
	])

func is_resource() -> bool:
	return is_interesting and not is_text()
	
func is_image() -> bool:
	return contains_any(suffix, [
		"png", "jpeg", "jpg", "ktx", "svg", "tga", "webp"
	])
	
func is_model() -> bool:
	return contains_any(suffix, [
		"glb", "gltf"
	])

func is_native_sound() -> bool:
	return contains_any(suffix, [
		"wav", "ogg"
	])
	
func is_sound() -> bool:
	return is_native_sound()
	
func is_interesting() -> bool:
	var ret = directory_exists() or is_model() or is_image() or is_sound() or is_text()
	return ret
	
## Returns whether the path is scoped to the res:// directory
func is_res_path():
	return _root == "res"

## The file extension. res://my/path.png -> png
func _get_suffix() -> String:
	return get_local().get_extension()

## The filename without any directory. res://my/path.png -> path.png
func _get_name():
	return _string_path.get_file()

## The filename without the file extension
func _get_stem() -> String:
	if directory_exists():
		return ""
	return name.trim_suffix("." + suffix)
	
## Gets the local path. Could start with res://, or just some random relative path.
func get_local() -> String:
	return _string_path

## Gets the global OS level path. e.g., C:/...
func get_global() -> String:
	return ProjectSettings.globalize_path(get_local())
