class_name UnitCardDataResource extends Resource

@export var texture_art: Texture
@export_placeholder("Unit Name") var unit_name: String = "Error Unit Name"
@export_placeholder("World Name") var world_name: String = "Error Unit World"
@export_placeholder("Flavor Text") var flavour_text: String = "Error Flavour Text"
@export var hp: int = 0
@export var atk: int = 0
@export var pt: int = 0
@export var abilities: Array[AbilityTextDataResource] = []
@export var sp_atks: Array[SpAtkDataResource] = []
