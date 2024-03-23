@tool
extends PreviewBase

@export var player : AudioStreamPlayer
@export var progress_bar : ProgressBar
@export var label : Label

var current_stream : AudioStream
var looping = false
	
func _on_file_tree_file_selected(filepath: FilePath) -> void:
	if filepath.is_native_sound():
		visible = true
		handle_file(filepath)
	else:
		visible = false

func handle_file(filepath : FilePath):
	current_stream = load(filepath.get_local()) as AudioStream
	
	if current_stream is AudioStreamWAV:
		pass
		#current_stream.loop_mode = AudioStreamWAV.LOOP_PINGPONG
	elif current_stream is AudioStreamOggVorbis:
		current_stream.loop = looping
	
	player.stream = current_stream
	player.play()
	
	current_stream.get_length()
	
	
func _on_loop_button_toggled(toggled_on: bool) -> void:
	looping = toggled_on
	current_stream.loop = toggled_on


func _on_restart_button_pressed() -> void:
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	pass # Replace with function body.


func _on_stop_button_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
