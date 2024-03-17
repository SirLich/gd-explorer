extends LineEdit

func _on_text_submitted(new_text: String) -> void:
	await get_tree().process_frame
	clear()
