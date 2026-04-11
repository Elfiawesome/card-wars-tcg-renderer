@tool
class_name SPAtkGridTile extends NinePatchRect

const FILLED_TEXTURE = preload("uid://xuj08j83x4y")
const TRANSPARENT_TEXTURE = preload("uid://cvrfpn3tfvp6")

@onready var cross_texture: TextureRect = $MarginContainer/CrossTexture

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

@export var cross_atk: bool = false:
	set(value):
		cross_atk = value
		cross_texture.visible = cross_atk

@export var tile_color: Color:
	set(value):
		tile_color = value
		cross_texture.modulate.r = value.r
		cross_texture.modulate.g = value.g
		cross_texture.modulate.b = value.b
		self_modulate = tile_color
