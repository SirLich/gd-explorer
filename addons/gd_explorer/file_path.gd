@tool
extends RefCounted
class_name FilePath

var _root : String
var _components : PackedStringArray

var ROOT_DELIM : StringName = "://"

static func from_string(string_path : String) -> FilePath:
	return FilePath.new(string_path)

static func contains_any(s: String, opts : PackedStringArray):
	for opt in opts:
		if s.contains(opt):
			return true
	return false
	
func _init(string_path : String) -> void:
	string_path = string_path.replace("\\\\", "/")
	string_path = string_path.replace("\\", "/")
	if string_path.contains(ROOT_DELIM):
		var split = string_path.split(ROOT_DELIM)
		_root = split[0]
		string_path = split[1]
	string_path = string_path.replace("//", "/")
	string_path = string_path.replace("//", "/")
	
	_components = string_path.split("/")
	
var suffix : String : get = _get_suffix
var suffixes : PackedStringArray : get = _get_suffixes
var name : String : get = _get_name
var stem : String : get = _get_stem
var parent : FilePath : get = _get_parent
	
func copy_to_cache() -> FilePath:
	var to_file = FilePath.from_string("res://addons/gd_explorer/cache/").join(name)
	if not FileAccess.file_exists(to_file.get_global()):
		DirAccess.copy_absolute(get_global(), to_file.get_global())
	return to_file
	
func _has_root() -> bool:
	return _root != ""

func _duplicate() -> FilePath:
	return FilePath.from_string(get_local())
	
## Returns whether this is a directory, and that it exists
func directory_exists() -> bool:
	return DirAccess.dir_exists_absolute(get_global())

func join(variadic_path) -> FilePath:
	if is_file():
		push_warning(".join was called on %s, but it's a file" % get_local())
		return
	var new_fp = _duplicate()
	new_fp._components.append(variadic_path)
	return new_fp

## Returns whether this appears to be a file-like object. Does not imply it exists.
func is_file() -> bool:
	return file_exists()

## Returns whether this appears to be a dir-like object. Does not imply it exists.
func is_directory() -> bool:
	return not is_file()
	
## Returns whether this is a file, and that it exists
func file_exists() -> bool:
	return FileAccess.file_exists(get_local())

## Returns all children (direcoties first, then files)
func get_children() -> Array[FilePath]:
	var out : Array[FilePath] = []
	out.append_array(get_directories())
	out.append_array(get_files())
	return out
	
## Returns all the directories that are a direct child of this path
func get_directories() -> Array[FilePath]:
	var out : Array[FilePath] = []
	for fp in DirAccess.get_directories_at(get_local()):
		var t = self.join(fp)
		out.append(FilePath.from_string(t.get_local()))
	return out

## Returns all the files that are a direct child of this path
func get_files() -> Array[FilePath]:
	var out : Array[FilePath] = []
	for fp in DirAccess.get_files_at(get_local()):
		out.append(FilePath.from_string(self.join(fp).get_local()))
	return out

## Returns whether this path appears to be a valid file or directory
func exists():
	return file_exists() or directory_exists()

## Returns whether the path is scoped to the user:// directory.
func is_user_path():
	return _root == "user"
	
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
	
func is_known_type() -> bool:
	return is_model() or is_image() or is_sound()
	
## Returns whether the path is scoped to the res:// directory
func is_res_path():
	return _root == "res"

## The file extension. res://my/path.png -> png
func _get_suffix() -> String:
	if is_directory():
		push_warning("Suffix for %s could not be resolved, as it appears to be a directory" % get_local())
		return ""
		
	return get_local().get_extension()

## A list of the path’s file extensions:. res://my/path.temp.png -> ["temp", "png"]
func _get_suffixes() -> PackedStringArray:
	if is_directory():
		push_warning("Suffixes for %s could not be resolved, as it appears to be a directory" % get_local())
		return []
		
	return name.split(".")[0].split(".")

## The filename without any directory. res://my/path.png -> path.png
func _get_name():
	return _components[_components.size() - 1]

## The filename without the file extension
func _get_stem() -> String:
	if is_directory():
		push_warning("Stem for %s could not be resolved, as it appears to be a directory" % get_local())
	return name.trim_suffix("." + suffix)

## The directory containing the file, or the parent directory if the path is a directory
func _get_parent() -> FilePath:
	return FilePath.from_string(get_local().rsplit("/", true, 1)[0])

## Gets the local path. Could start with res://, or just some random relative path.
func get_local() -> String:
	if _has_root():
		return _root + ROOT_DELIM + "/".join(_components)
	return "/".join(_components)

## Gets the global OS level path. e.g., C:/...
func get_global() -> String:
	return ProjectSettings.globalize_path(get_local())
