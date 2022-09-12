extends Node2D

onready var grid = get_parent()

var agent_texture     = preload("res://Assets/capibara.png")
var objective_texture = preload("res://Assets/carrot.png")
var obstacle_texture  = preload("res://icon.png")

var tile_to_paint = Vector2(14, 14)

var items_dictionary = {
	"agent"     : agent_texture,
	"objective" : objective_texture,
	"obstacle"  : obstacle_texture
}

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var tile_pos = grid.world_to_map(mouse_pos)
	var tile_cell_at_mouse_pos = grid.get_cell(tile_pos.x, tile_pos.y)

	redraw(tile_pos)

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

func _input(event):
	if event.is_action_pressed("left_click"):
		if !GameData.editor_selected_item: return 
		
		var mouse_pos = get_global_mouse_position()
		var tile_pos = grid.world_to_map(mouse_pos)
		
		if grid.get_cell(tile_pos.x, tile_pos.y) == grid.INVALID_CELL: return
		
		var new_object = grid.obstacle.instance()
		new_object.get_node("Sprite").set_texture(items_dictionary[GameData.editor_selected_item])
		new_object.position = (grid.map_to_world(tile_pos) + grid.half_tile_size)
		grid.add_child(new_object)
		grid.positions.append(tile_pos)
		GameData.items_positions[GameData.editor_selected_item].append(tile_pos)
