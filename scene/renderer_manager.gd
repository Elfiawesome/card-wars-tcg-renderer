class_name RendererManager extends SubViewport


func render(save_path: String, unit_card: Control) -> void:
	var upscale: float = 4.0
	add_child(unit_card)
	size = unit_card.size * upscale
	
	unit_card.scale = Vector2(upscale, upscale)
	unit_card.position = -unit_card.size / 2 + unit_card.size*upscale / 2
	
	# Wait for the Control layout to update, and the Viewport to draw.
	# Two process frames guarantees the Viewport has updated.
	await get_tree().process_frame
	await get_tree().process_frame
	
	var image := get_texture().get_image()
	var err := image.save_png(save_path + ".png")
	
	if err != OK:
		printerr("Failed to save image at: ", save_path, " Error code: ", err)
	
	unit_card.queue_free()
