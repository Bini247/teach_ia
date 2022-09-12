extends TileMap

onready var obstacle = preload("res://Agents/Obstacle/Obstacle.tscn")

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

var OBSTACLE

var grid_size = Vector2(13,13)
var grid = []

var inputs = [
	'ui_up',
	'ui_down',
	'ui_left',
	'ui_right'
]

var positions = []

var object_dictionary

func _ready():
	randomize()
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			set_cell(x, y, 9)
			grid[x].append(null)
	
	set_tile_positions()
	
	var player_position = Vector2(1,6)

func set_tile_positions():
	for n in range(grid_size.x):
		var grid_pos = Vector2(n, 0)
		if not grid_pos in positions:
			set_cell(n, 0, 11)
			if n == 0: set_cell(n, 0, 13)
			positions.append(grid_pos)
		grid_pos = Vector2(0, n)
		if not grid_pos in positions:
			set_cell(0, n, 15)
			positions.append(grid_pos)
		grid_pos = Vector2(n, grid_size.x-1)
		if not grid_pos in positions:
			set_cell(n, grid_size.x-1, 16)
			if n == 0: set_cell(n, grid_size.x-1, 18)
			if n == grid_size.x-1: set_cell(n, grid_size.x-1, 17)
			positions.append(grid_pos)
		grid_pos = Vector2(grid_size.x-1, n)
		if not grid_pos in positions:
			set_cell(grid_size.x-1, n, 14)
			if n == 0: set_cell(grid_size.x-1, 0, 12)
			positions.append(grid_pos)
	
	if GameData.items_positions['obstacle'].size() > 0:
		for obstacle_pos in GameData.items_positions['obstacle']:
			positions.append(obstacle_pos)
			var new_object = obstacle.instance()
			new_object.position = (map_to_world(obstacle_pos) + half_tile_size)
			add_child(new_object)
