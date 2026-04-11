@tool
class_name SPAtkGridTile extends NinePatchRect

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
		var label: Label = $MarginContainer/Label
		if value > 0:
			label.visible = true
		else:
			label.visible = false
		label.text = str(value)

@export var tile_color: Color:
	set(value):
		tile_color = value
		self_modulate = tile_color
