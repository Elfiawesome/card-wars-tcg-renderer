@tool
extends NinePatchRect

const FILLED_TEXTURE = preload("uid://xuj08j83x4y")
const TRANSPARENT_TEXTURE = preload("uid://cvrfpn3tfvp6")

@export var filled: bool = false:
	set(value):
		filled = value
		if value:
			texture = FILLED_TEXTURE
		else:
			texture = TRANSPARENT_TEXTURE

@export var number: int = 0:
	set(value):
		number = value
		if value > 0:
			$MarginContainer/Label.visible = true
		else:
			$MarginContainer/Label.visible = false
		$MarginContainer/Label.text = str(value)

@export var tile_color: Color:
	set(value):
		tile_color = value
		self_modulate = tile_color
