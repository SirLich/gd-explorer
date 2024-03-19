@tool
extends Node2D

@onready var texture_rect: TextureRect = $Control/TextureRect

func _ready() -> void:
	var root = "C:\\liam\\assets"
	var example_asset = "C:\\liam\\assets\\kenny_assets\\2D assets\\Animal Pack Redux\\Preview.png"
	for dir in DirAccess.get_directories_at(root):
		print(dir)
		
	var image : Image = Image.load_from_file(example_asset)
	
	texture_rect.texture = ImageTexture.create_from_image(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
