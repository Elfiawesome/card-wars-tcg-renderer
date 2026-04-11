class_name RendererManager extends SubViewport

func _ready() -> void:
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	transparent_bg = true 

func render(save_path: String, unit_card: Control) -> void:
	var upscale: float = 4.0
	var original_parent := unit_card.get_parent()
	original_parent.remove_child(unit_card)
	add_child(unit_card)
	
	size = unit_card.size * upscale
	
	# Set pivot to Top-Left to ensure scaling pushes the card down and right
	unit_card.pivot_offset = Vector2.ZERO
	unit_card.scale = Vector2(upscale, upscale)
	unit_card.position = -unit_card.size / 2 + unit_card.size*upscale / 2
	
	# Two frames guarantee the Control layout has updated AND the Viewport has rendered.
	await get_tree().process_frame
	await get_tree().process_frame
	
	var image := get_texture().get_image()
	var err := image.save_png(save_path + ".png")
	
	if err != OK:
		printerr("Failed to save image at: ", save_path, " Error code: ", err)
	
	remove_child(unit_card)
	original_parent.add_child(unit_card)
