@tool
extends PreviewBase

@export var player : AudioStreamPlayer

var current_stream : AudioStream
var looping = false

func _ready() -> void:
	EditorInterface.get_resource_filesystem().filesystem_changed.connect(filesystem_changed)
	EditorInterface.get_resource_filesystem().resources_reload.connect(resources_reload)
	EditorInterface.get_resource_filesystem().resources_reimported.connect(resources_reimported)

func filesystem_changed():
	print("filesystem_changed")
	
func resources_reload():
	print("resources_reload")

func resources_reimported():
	print("resources_reimported")
	
func _on_file_tree_file_selected(filepath: FilePath) -> void:
	if filepath.is_native_sound():
		visible = true
		handle_file(filepath)
	else:
		visible = false

func handle_file(filepath : FilePath):
	var new_path = filepath.copy_to_cache().get_local()
	EditorInterface.get_resource_filesystem().scan_sources()
	EditorInterface.get_resource_filesystem().scan()
	
	if not ResourceLoader.exists(new_path):
		await EditorInterface.get_resource_filesystem().filesystem_changed
	
	current_stream = load(new_path)
	
	if current_stream is AudioStreamWAV:
		pass
		#current_stream.loop_mode = AudioStreamWAV.LOOP_PINGPONG
	elif current_stream is AudioStreamOggVorbis:
		current_stream.loop = looping
	
	player.stream = current_stream
	player.play()
	
	
	#if filepath.suffix == "ogg":
		#current_stream = AudioStreamOggVorbis.load_from_file(filepath.get_global())
	#elif filepath.suffix == "wav":
		#current_stream = WavImporter.load_wav(filepath.get_global())
	#else:
		#push_error("Filepath % tried to load as sound, but could not be understood" % filepath.get_global())
	

	
func _on_loop_button_toggled(toggled_on: bool) -> void:
	looping = toggled_on
	current_stream.loop = toggled_on


