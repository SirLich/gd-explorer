@tool
extends PreviewBase

@export var player : AudioStreamPlayer

var current_stream : AudioStream
var looping = false

func on_file_selected(path : FilePath):
	if path.suffix == "ogg":
		visible = true
		current_stream = AudioStreamOggVorbis.load_from_file(path.get_global())
		current_stream.loop = looping
		player.stream = current_stream
		player.play()
	else:
		visible = false

func _on_loop_button_toggled(toggled_on: bool) -> void:
	looping = toggled_on
	current_stream.loop = toggled_on
