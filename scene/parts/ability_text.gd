@tool
extends HBoxContainer

@export var color: Color = Color.RED:
	set(value):
		color = value
		$AbilityTriggerContainer/ColorRect.color = value

@export var trigger_texture: Texture2D = preload("res://asset/textures/icon/ri--error-warning-fill.svg"):
	set(value):
		trigger_texture = value
		$AbilityTriggerContainer/HBoxContainer/Control/MarginContainer/TextureRect.texture = trigger_texture

@export var trigger_name: String = "ERROR":
	set(value):
		trigger_name = value
		$AbilityTriggerContainer/HBoxContainer/MarginContainer/Label.text = value

@export var description: String = "Error":
	set(value):
		description = value
		$AbilityDescription.text = value
