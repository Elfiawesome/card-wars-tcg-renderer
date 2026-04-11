extends Node2D

const UNIT_CARD_SCENE = preload("uid://8c5qmt2osg8k")

@onready var data_manager: DataManager = $DataManager
@onready var renderer_manager: RendererManager = $RendererManager

func _ready() -> void:
	#data_manager.load_all("res://data")
	#await data_manager.finished_loading
	
	var card : UnitCard = UNIT_CARD_SCENE.instantiate()
	renderer_manager.render("res://hi", card)
