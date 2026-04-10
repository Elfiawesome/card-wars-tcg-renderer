@tool
extends GridContainer

const TILE = preload("res://scene/parts/sp_grid_tile.tscn")

@export var tile_color : Color = Color("2979ff"):
	set(value):
		tile_color = value
		pattern = pattern

@export_multiline() var pattern = "0,0,0\n0,0,0\n0,0,0":
	set(value):
		pattern = value
		columns = 1
		for c in get_children():
			remove_child(c)
			c.queue_free()
		
		value.replace("\n", ",")
		if !value.is_empty():
			var max_rows: int = 0
			var grid: Array[Array] = []
			for y in value.split("\n"):
				var row: Array = []
				for x in y.split(","):
					var tile := TILE.instantiate()
					add_child(tile)
					
					if x == "0" or x == "o" or x == "O":
						tile.filled = false
					elif x == "X" or x == "x":
						tile.filled = true
						tile.tile_color = tile_color
					elif x.is_valid_int():
						tile.number = x.to_int()
						tile.tile_color = tile_color
					
					row.append(x)
				if row.size() > max_rows: max_rows = row.size()
				grid.append(row)
			columns = max_rows
