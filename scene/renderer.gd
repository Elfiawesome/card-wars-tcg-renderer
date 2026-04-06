extends Node2D

@onready var unit_card: Control = $UnitCard
@onready var renderer: SubViewport = $Renderer

func _ready() -> void:
	_render()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pass

func _render() -> void:
	renderer.size = unit_card.get_child(0).size * 2
	var original_parent := unit_card.get_parent()
	unit_card.reparent(renderer)
	unit_card.scale = Vector2(2,2)
	
	# WAIT for the engine to render the viewport
	await RenderingServer.frame_post_draw
	
	var image := renderer.get_texture().get_image()
	image.save_png("res://asset/render_exports/1.png")
	print("Saved!")
	unit_card.reparent(original_parent)
