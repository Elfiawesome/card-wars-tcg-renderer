@tool
class_name UnitCard extends Control

const ABILITY_TEXT_SCENE := preload("uid://bcn8333rsty1y")
const SP_GRID_CONTAINER_SCENE = preload("uid://dldi24576xf83")


@onready var card_container: Control = $CardContainer

@onready var texture_art: TextureRect = $CardContainer/TextureContainer/TextureArt
@onready var unit_name_label: Label = $CardContainer/InfoContainer/TopInfoContainer/NameInfoContainer/HBoxContainer/RightInfoContainer/Label
@onready var world_label: Label = $CardContainer/InfoContainer/TopInfoContainer/NameInfoContainer/HBoxContainer/RightInfoContainer/WorldContainer/WorldLabel
@onready var hp_label: Label = $CardContainer/InfoContainer/BottomInfoContainer/MainInfoContainer/MainInfoContainer/StatContainer/HBoxContainer/HpContainer/HBoxContainer/Label
@onready var atk_label: Label = $CardContainer/InfoContainer/BottomInfoContainer/MainInfoContainer/MainInfoContainer/StatContainer/HBoxContainer/AtkContainer/HBoxContainer/Label
@onready var pt_label: Label = $CardContainer/InfoContainer/TopInfoContainer/NameInfoContainer/HBoxContainer/PointBox/PointContainer/Label
@onready var flavour_text_label: Label = $CardContainer/InfoContainer/BottomInfoContainer/MainInfoContainer/MainInfoContainer/Label

@onready var abilities_container: VBoxContainer = $CardContainer/InfoContainer/BottomInfoContainer/MainInfoContainer/MainInfoContainer/AbilityAndSPAtkContainer/AbilitiesContainer
@onready var sp_atk_container: VBoxContainer = $CardContainer/InfoContainer/BottomInfoContainer/MainInfoContainer/MainInfoContainer/AbilityAndSPAtkContainer/SPAtkContainer
@onready var sp_atk_container_inner: HBoxContainer = $CardContainer/InfoContainer/BottomInfoContainer/MainInfoContainer/MainInfoContainer/AbilityAndSPAtkContainer/SPAtkContainer/HBoxContainer


@export var unit_data: UnitCardDataResource:
	set(value):
		unit_data = value
		reset_data()
		load_data(value)

func reset_data() -> void:
	for child in abilities_container.get_children():
		child.queue_free()
	for child in sp_atk_container_inner.get_children():
		child.queue_free()
	
	abilities_container.visible = false
	sp_atk_container.visible = false
	sp_atk_container.size_flags_horizontal = Control.SIZE_FILL

func load_data(data: UnitCardDataResource) -> void:
	texture_art.texture = data.texture_art
	unit_name_label.text = data.unit_name
	world_label.text = data.world_name
	hp_label.text = str(data.hp)
	atk_label.text = str(data.atk)
	pt_label.text = str(data.pt)
	flavour_text_label.text = data.flavour_text
	
	if !data.abilities.is_empty(): abilities_container.visible = true
	for a in data.abilities:
		var ability: AbilityText = ABILITY_TEXT_SCENE.instantiate()
		abilities_container.add_child(ability)
		ability.ability_data = a
	
	if !data.sp_atks.is_empty(): sp_atk_container.visible = true
	for s in data.sp_atks:
		var sp_atk_grid: SPAtkGridContainer = SP_GRID_CONTAINER_SCENE.instantiate()
		sp_atk_grid.pattern = s.pattern
		sp_atk_container_inner.add_child(sp_atk_grid)
	
	if data.abilities.is_empty() && !data.sp_atks.is_empty():
		sp_atk_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
