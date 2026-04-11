class_name DataManager extends Node

signal finished_loading

var _pending_requests_works: int = 0

var ABILITY_TYPES: Dictionary[String, Dictionary] = {}
var SP_ATKS: Dictionary[String, Dictionary] = {}
var ARTS: Dictionary[String, Texture] = {}
var UNIT_DEF: Dictionary[String, UnitCardDataResource] = {}

func load_all(dir: String = "res://data") -> void:
	var root_dir := DirAccess.open(dir)
	
	var unit_dir := open_relative(root_dir, "units")
	var art_dir := open_relative(root_dir, "art")
	var ability_types_dir := open_relative(root_dir, "ability_types")
	var sp_atk_dir := open_relative(root_dir, "sp_atks")
	
	if art_dir:
		for ad in get_all_files(art_dir):
			var file_path := art_dir.get_current_dir().path_join(ad)
			var art_id := ad
			
			var img := Image.load_from_file(file_path)
			var texture := ImageTexture.create_from_image(img)
			ARTS[art_id] = texture
	
	if ability_types_dir:
		for at in get_all_files(ability_types_dir):
			
			var file_path := ability_types_dir.get_current_dir().path_join(at)
			var fa := FileAccess.open(file_path, FileAccess.READ)
			var data: Dictionary = JSON.parse_string(fa.get_as_text())
			var ability_id := at.get_basename()
			
			ABILITY_TYPES[ability_id] = data
			
			var icon_url: String = data.get("icon", "")
			if not icon_url.is_empty():
				_download_icon(ability_id, icon_url)
	
	if sp_atk_dir:
		for sa in get_all_files(sp_atk_dir):
			var file_path := sp_atk_dir.get_current_dir().path_join(sa)
			var fa := FileAccess.open(file_path, FileAccess.READ)
			var data: Dictionary = JSON.parse_string(fa.get_as_text())
			var sp_atk_id := sa.get_basename()
			
			SP_ATKS[sp_atk_id] = data
	
	await finished_loading
	
	if unit_dir:
		for u in get_all_files(unit_dir):
			var file_path := unit_dir.get_current_dir().path_join(u)
			var fa := FileAccess.open(file_path, FileAccess.READ)
			var data: Dictionary = JSON.parse_string(fa.get_as_text())
			var unit_id := u.get_basename()
			
			var unit := UnitCardDataResource.new()
			if data.has("art"):
				var art: Dictionary = data.get("art", {})
				if art.has("src"):
					var texture: Texture = ARTS.get(art["src"], null)
					if texture != null: unit.texture_art = texture
			if data.has("name"): unit.unit_name = data.get("name")
			if data.has("world"): unit.world_name = data.get("world")
			if data.has("flavour_text"): unit.flavour_text = data.get("flavour_text")
			if data.has("hp"): unit.hp = data.get("hp")
			if data.has("atk"): unit.atk = data.get("atk")
			if data.has("pt"): unit.pt = data.get("pt")
			
			if data.has("abilities"):
				for a: Dictionary in data.get("abilities", []):
					var a_type: String = a.get("type")
					var a_desc: String = a.get("description")
					var a_type_data: Dictionary = ABILITY_TYPES.get(a_type, {})
					
					var abtr := AbilityTextDataResource.new()
					if a_type_data.has("color"): abtr.color = a_type_data.get("color")
					if a_type_data.has("texture"): abtr.icon_texture = a_type_data.get("texture")
					if a_type_data.has("name"): abtr.name = a_type_data.get("name")
					abtr.description = a_desc
					
					unit.abilities.push_back(abtr)
			
			if data.has("sp_atks"):
				for sp: Dictionary in data.get("sp_atks", []):
					if sp.has("type"):
						var sp_type: String= sp.get("type")
						var sp_data: Dictionary = SP_ATKS.get(sp_type, {})
						var sp_pattern: String = sp_data.get("pattern", "")
						if sp_type == "custom":
							sp_pattern = sp.get("pattern", "")
						
						var spr := SpAtkDataResource.new()
						spr.pattern = sp_pattern
						
						unit.sp_atks.push_back(spr)
			
			UNIT_DEF[unit_id] = unit

# Helper functions
func open_relative(dir: DirAccess, path: String) -> DirAccess:
	if dir.dir_exists(path):
		var new_dir := DirAccess.open(dir.get_current_dir().path_join(path))
		return new_dir
	return null

func get_all_files(dir: DirAccess) -> Array[String]:
	var files: Array[String] = []
	_get_all_files_recursive(dir, files, "")
	return files

func _get_all_files_recursive(dir: DirAccess, files: Array[String], subsetfolder: String = "") -> void:
	for file in dir.get_files():
		if file.get_file().begins_with("."): continue
		files.push_back(subsetfolder + file)
	for d in dir.get_directories():
		var new_dir := DirAccess.open(dir.get_current_dir().path_join(d))
		var new_subsetfolder := subsetfolder.path_join(d).path_join("")
		_get_all_files_recursive(new_dir, files, new_subsetfolder)

func _download_icon(ability_id: String, url: String) -> void:
	_pending_requests_works += 1
	var http_req := HTTPRequest.new()
	add_child(http_req)
	
	http_req.request_completed.connect(
		func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
			var img := Image.new()
			var err := img.load_svg_from_buffer(body, 10.0)
			if err == OK:
				var img_tex := ImageTexture.create_from_image(img)
				ABILITY_TYPES[ability_id]["texture"] = img_tex
			
			http_req.queue_free()
			_pending_requests_works -= 1
			_check_if_finished()
	)
	http_req.request(url)

func _check_if_finished() -> void:
	if _pending_requests_works == 0:
		finished_loading.emit()
