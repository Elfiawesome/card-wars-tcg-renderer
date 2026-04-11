extends Node2D

const UNIT_CARD_SCENE = preload("uid://8c5qmt2osg8k")

@onready var data_manager: DataManager = $DataManager
@onready var renderer_manager: RendererManager = $RendererManager

func _ready() -> void:
	data_manager.load_all("C:/Users/elfia/Downloads/data")
	await data_manager.finished_loading
	print("Done Loading")
	
	for card_id in data_manager.UNIT_DEF:
		var card: UnitCard = UNIT_CARD_SCENE.instantiate()
		add_child(card)
		card.unit_data = data_manager.UNIT_DEF[card_id]
		
		var output_dir := "res://output/cards/" + card_id
		DirAccess.make_dir_recursive_absolute(output_dir.get_base_dir())
		
		# ADD AWAIT HERE: Wait for the render to finish before freeing the card
		await renderer_manager.render(output_dir, card)
		
		card.queue_free()
		
	print("All cards rendered successfully!")
