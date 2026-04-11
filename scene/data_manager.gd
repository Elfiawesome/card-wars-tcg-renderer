class_name DataManager extends Node

signal finished_loading

var pending_requests_works: int = 0
var root_dir: String = ""

var ABILITY_TYPE_DATA: Dictionary[String, Dictionary] = {}
var UNITS_DATA: Dictionary[String, Dictionary] = {}

func load_all(dir: String = "res://data") -> void:
	root_dir = dir
	
	# 1. Load Ability Types safely
	var ability_types_dir_path := dir.path_join("ability_types")
	if DirAccess.dir_exists_absolute(ability_types_dir_path):
		var ability_types_dir := DirAccess.open(ability_types_dir_path)
		for at in get_all_files(ability_types_dir):
			if at.get_file().begins_with("."): continue
			
			var file_path := ability_types_dir_path.path_join(at)
			var fa := FileAccess.open(file_path, FileAccess.READ)
			var data: Dictionary = JSON.parse_string(fa.get_as_text())
			var ability_id := at.get_basename()
			
			ABILITY_TYPE_DATA[ability_id] = data
			
			# Handle HTTP Request
			var icon_url: String = data.get("icon", "")
			if not icon_url.is_empty():
				_download_icon(ability_id, icon_url)
	
	# 2. Load Units safely
	var units_dir_path := dir.path_join("units")
	if DirAccess.dir_exists_absolute(units_dir_path):
		var units_dir := DirAccess.open(units_dir_path)
		for u in get_all_files(units_dir):
			if u.begins_with("."): continue
			
			var file_path := units_dir_path.path_join(u)
			var fa := FileAccess.open(file_path, FileAccess.READ)
			var data: Dictionary = JSON.parse_string(fa.get_as_text())
			
			var unit_id := u.get_basename()
			UNITS_DATA[unit_id] = data

	# 3. Check if we need to wait, or if we are already done
	_check_if_finished()

func _download_icon(ability_id: String, url: String) -> void:
	pending_requests_works += 1
	var http_req := HTTPRequest.new()
	add_child(http_req)
	
	http_req.request_completed.connect(
		func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
			var img := Image.new()
			var err := img.load_svg_from_buffer(body, 10.0)
			if err == OK:
				var img_tex := ImageTexture.create_from_image(img)
				ABILITY_TYPE_DATA[ability_id]["texture"] = img_tex
			
			http_req.queue_free()
			pending_requests_works -= 1
			_check_if_finished()
	)
	http_req.request(url)

func _check_if_finished() -> void:
	if pending_requests_works == 0:
		finished_loading.emit()

# Moved the formatting logic here to keep Main clean
func get_formatted_unit_data(unit_id: String) -> Dictionary:
	# Duplicate so we don't accidentally modify the cached raw data
	var unit_data := UNITS_DATA[unit_id].duplicate(true) 
	var abilities_data: Array = unit_data.get("abilities", [])
	var new_abilities: Array[Dictionary] = []
	
	for ad: Dictionary in abilities_data:
		var ability_type: String = ad.get("type", "")
		if ability_type.is_empty() or not ABILITY_TYPE_DATA.has(ability_type):
			continue
			
		var ability_type_data: Dictionary = ABILITY_TYPE_DATA[ability_type]
		
		new_abilities.append({
			"color": Color(ability_type_data.get("color", "ffffff")),
			"description": ad.get("description", ""),
			"icon_texture": ability_type_data.get("texture"),
			"name": ability_type_data.get("name", "Unknown"),
		})
		
	unit_data["abilities"] = new_abilities
	return unit_data

func get_all_files(dir: DirAccess) -> Array[String]:
	var files: Array[String] = []
	_get_all_files_recursive(dir, files, "")
	return files

func _get_all_files_recursive(dir: DirAccess, files: Array[String], subsetfolder: String = "") -> void:
	for file in dir.get_files():
		files.push_back(subsetfolder + file)
	for d in dir.get_directories():
		var new_dir := DirAccess.open(dir.get_current_dir().path_join(d))
		var new_subsetfolder := subsetfolder.path_join(d).path_join("")
		_get_all_files_recursive(new_dir, files, new_subsetfolder)
