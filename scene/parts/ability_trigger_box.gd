@tool
extends MarginContainer

@onready var label: Label = $HBoxContainer/MarginContainer/Label

@export var ability_type: String:
	set(value):
		ability_type = value
		label.text = value
		if value.is_empty():
			$HBoxContainer/MarginContainer.visible = false
		else:
			$HBoxContainer/MarginContainer.visible = true
