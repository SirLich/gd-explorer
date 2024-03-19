@tool
extends TextureRect
class_name ImagePreview

var SCALE_FACTOR = 0.1

var _tex : Image
var tex_scale = Vector2(1,1)
var original_size : Vector2i
	
func configure(image: Image) -> void:
	_tex = image
	original_size = image.get_size()
	set_and_resize_texture()

func set_and_resize_texture():
	if _tex:
		print(tex_scale)
		var new_size = Vector2i(Vector2(original_size) * tex_scale)
		var new_tex = _tex.duplicate()
		new_tex.resize(new_size.x, new_size.y, Image.INTERPOLATE_BILINEAR)

		texture = ImageTexture.create_from_image(new_tex)
		pivot_offset = size/2
