extends Node2D

onready var grid = get_parent()

var tile_to_paint = Vector2(14, 14)

func redraw(tile):
	tile_to_paint = tile
	update()

func _draw():
	var colour = PoolColorArray()
	colour = [Color(1,1,1,0.4)]
	if grid.get_cell(tile_to_paint.x, tile_to_paint.y) == grid.INVALID_CELL || grid.get_cellv(tile_to_paint) > 9: 
		colour = [Color(1,1,1,0)] 
	
	var points = PoolVector2Array()
	points = [Vector2(tile_to_paint.x * grid.cell_size.x, tile_to_paint.y * grid.cell_size.y), Vector2((tile_to_paint.x +1) * grid.cell_size.x, tile_to_paint.y * grid.cell_size.y), Vector2((tile_to_paint.x + 1)* grid.cell_size.x, (tile_to_paint.y + 1) * grid.cell_size.y ),Vector2(tile_to_paint.x * grid.cell_size.x, (tile_to_paint.y+1) * grid.cell_size.y)]
	draw_polygon(points,colour)
