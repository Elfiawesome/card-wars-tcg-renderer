@tool
class_name AbilityText extends HBoxContainer



@export var ability_data: AbilityTextDataResource:
	set(value):
		ability_data = value
		($AbilityTriggerContainer/ColorRect as ColorRect).color = value.color
		($AbilityTriggerContainer/HBoxContainer/Control/MarginContainer/TextureRect as TextureRect).texture = value.icon_texture
		($AbilityTriggerContainer/HBoxContainer/MarginContainer/Label as Label).text = value.name
		($AbilityDescription as Label).text = value.description
