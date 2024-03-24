@tool
extends MarginContainer

@export var player : AudioStreamPlayer
@export var slider : Slider
@export var clip_title : Label

var current_stream : AudioStream
var looping = false

func is_playing() -> bool:
	return player.playing
	
	
func _on_file_tree_file_selected(filepath: FilePath) -> void:
	if filepath.is_native_sound():
		visible = true
		handle_file(filepath)
	else:
		visible = false

func _process(delta: float) -> void:
	if current_stream and player and not player.stream_paused:
		slider.value = player.get_playback_position() / current_stream.get_length() * 1000
		
func handle_file(filepath : FilePath):
	current_stream = load(filepath.get_local()) as AudioStream
	
	clip_title.text = filepath.stem
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


func _on_restart_button_pressed() -> void:
	player.play()


func _on_play_button_pressed() -> void:
	player.stream_paused = !player.stream_paused


func _on_stop_button_pressed() -> void:
	player.stop()


func _on_audio_stream_player_finished() -> void:
	if looping:
		_on_restart_button_pressed()


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	player.play(slider.value * current_stream.get_length() / 1000)
	player.stream_paused = false
	print("Drag ended")

func _on_h_slider_drag_started() -> void:
	player.stream_paused = true
