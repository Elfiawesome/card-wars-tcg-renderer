extends GridContainer

const SP_GRID_TILE = preload("uid://cyss4lrjmihad")

@export_multiline var pattern: String:
	set(value):
		pattern = value
		for c in get_children():
			remove_child(c)
			c.queue_free()
		
		for row in value.split("\n"):
			for cell in row.split(","):
				var new_tile := SP_GRID_TILE.instantiate()
				add_child(new_tile)
