extends Node2D

export var auto_restart = true
export var allow_inputs = true
export var show_display = true

onready var grid = get_parent().get_node("Grid")

var dead = false

var game_size = Vector2(416, 416)

var cell_size = Vector2(32, 32)

var player_direction = DIR.DOWN

var food = Vector2()

enum DIR {LEFT, UP, RIGHT, DOWN}

var points = 0
var max_points = 0

var player
var chest

onready var Player = preload("res://Agents/Player/Player.tscn")
onready var Chest = preload("res://Agents/Chest/Chest.tscn")

func _ready():
	$CanvasLayer/UserInterface/VBoxContainer/Points.text = "Points: " + str(points)
	$CanvasLayer/UserInterface/VBoxContainer/MaxPoints.text = "Record: " + str(max_points)
	set_speed_mode(1)
	randomize()
	
	player = Player.instance()
	chest = Chest.instance()
	add_child(player)
	add_child(chest)
	reset()

func set_speed_mode(current_speed):
	Engine.time_scale = current_speed

func reset():
	var middle = int(game_size.x / 2 / cell_size.x)
	player.position = grid.map_to_world(Vector2(middle, middle))
	player_direction = DIR.DOWN
	dead = false
	spawn_food()

func _input(event):
	if not allow_inputs:
		return
	
	if Input.is_action_just_pressed("ui_down"):
		player_direction = DIR.DOWN
	if Input.is_action_just_pressed("ui_up"):
		player_direction = DIR.UP
	if Input.is_action_just_pressed("ui_left"):
		player_direction = DIR.LEFT
	if Input.is_action_just_pressed("ui_right"):
		player_direction = DIR.RIGHT

func move_player():
	var old_pos = player.position
	match(player_direction):
		DIR.DOWN:
			player.position.y += 32
		DIR.UP:
			player.position.y -= 32
		DIR.LEFT:
			player.position.x -= 32
		DIR.RIGHT:
			player.position.x += 32
	
	var old_dir = player_direction
	
	var current_position = grid.world_to_map(player.position)
	
	if current_position in grid.positions: on_death()
	
	if current_position == food:
		points += 1
		$CanvasLayer/UserInterface/VBoxContainer/Points.text = "Points: " + str(points)
		if points > max_points:
			max_points = points
			$CanvasLayer/UserInterface/VBoxContainer/MaxPoints.text = "Record: " + str(max_points)
			
		spawn_food()

func on_death():
	points = 0
	$CanvasLayer/UserInterface/VBoxContainer/Points.text = "Points: " + str(points)
	get_parent().length = 0
	if auto_restart:
		reset()
	else:
		dead = true

func spawn_food():
	var x = randi() % int(game_size.x / cell_size.x)
	var y = randi() % int(game_size.x / cell_size.x)
	
	food = Vector2(x, y)
	
	while food in grid.positions:
		x = randi() % int(game_size.x / cell_size.x)
		y = randi() % int(game_size.x / cell_size.x)
		
		food = Vector2(x, y)
	
	if food == grid.world_to_map(player.position):
		spawn_food()
	
	chest.position = grid.map_to_world(food)
