extends Node2D

const UNIT_CARD_SCENE = preload("uid://8c5qmt2osg8k")

@onready var data_manager: DataManager = $DataManager
@onready var renderer: SubViewport = $Renderer

func _ready() -> void:
	# Ensure the SubViewport is set up correctly for rendering
	renderer.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	# Pass the directory to the DataManager
	data_manager.load_all("res://data")
	await data_manager.finished_loading
	
	# Prepare the export directory safely
	var export_dir := data_manager.root_dir.path_join("export").path_join("cards")
	DirAccess.make_dir_recursive_absolute(export_dir)
	
	## Process units sequentially using await
	#for id: String in data_manager.UNITS_DATA:
		## Ask DataManager for the fully formatted data
		#var unit_data: Dictionary = data_manager.get_formatted_unit_data(id)
		#
		#var unit_card: UnitCard = UNIT_CARD_SCENE.instantiate()
		#add_child(unit_card)
		#unit_card.load_from_data(unit_data)
		#
		#var save_path := export_dir.path_join(id + ".png")
		#
		## We MUST await here so the loop pauses while rendering finishes
		#await render(save_path, unit_card, unit_card.card_container.size)
		#
		## Clean up to prevent memory leaks!
		#unit_card.queue_free()
		#
	#print("All cards rendered successfully!")

func render(save_path: String, unit_card: Control, render_size: Vector2) -> void:
	var upscale: float = 3.0
	renderer.size = render_size * upscale
	
	var original_parent := unit_card.get_parent()
	unit_card.reparent(renderer)
	unit_card.scale = Vector2(upscale, upscale)
	
	# Wait for the Control layout to update, and the Viewport to draw.
	# Two process frames guarantees the Viewport has updated.
	await get_tree().process_frame
	await get_tree().process_frame
	
	var image := renderer.get_texture().get_image()
	var err := image.save_png(save_path)
	
	if err != OK:
		printerr("Failed to save image at: ", save_path, " Error code: ", err)
		
	# Put it back
	unit_card.reparent(original_parent)
