extends Node2D

const SPAWN = preload("res://spawn.tscn")
@export var noise_height_texture : NoiseTexture2D
var noise : Noise

var width : int = 512
var height : int = 512

@onready var tile_map: TileMapLayer = $Layer0
var source_id = 2
#var water_atlas = Vector2i(0,3)
#var land_atlas = Vector2i(0,2)
#var sand_atlas = Vector2i(1,2)
var water_atlas = Vector2i(24,29)
var land_atlas = Vector2i(30,16)
var sand_atlas = Vector2i(29,18)

var tree_atlas = Vector2i(44,4)

var gridData : Dictionary = {}

var tree_counter: int = 0

@onready var intro: Sprite2D = $intro
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var rich_text_label: RichTextLabel = $CanvasLayer/Control/VBoxContainer/RichTextLabel

func _ready():
	randomize()
	reset_world()
	
	
func reset_world():
	noise = noise_height_texture.noise
	noise.seed = randi()
	noise.frequency = 0.01
	noise.frequency = snappedf(randf_range(0.02, 0.08), 0.0001)
	generate_world()
	
func generate_world():
	gridData = {}
	for x in range(width):
		for y in range(height):
			var noise_val: float = noise.get_noise_2d(x,y)
			if noise_val >=0.1:
				 #set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)
				tile_map.set_cell(Vector2i(x,y), source_id, land_atlas)
				pass
			elif noise_val >=0.0 and noise_val < 0.1:
				 #set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)
				tile_map.set_cell(Vector2i(x,y), source_id, sand_atlas)
			elif noise_val < 0.0:
				tile_map.set_cell(Vector2i(x,y), source_id, water_atlas)
				pass
	var cells = tile_map.get_used_cells()
	for cell in cells:
		gridData[cell] = CellData.new()
		gridData[cell].set_type(land_atlas)
	#print(gridData)

func get_clicked_tile_power():
	
	if Globals.game_started == false:
		return
	
	var clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	#print(tile_map.get_local_mouse_position())
	var data = tile_map.get_cell_tile_data(clicked_cell)
	#print(gridData[clicked_cell])
	


	if data and gridData[clicked_cell].isOccupied == false:
		#print(data.get_custom_data('is_available'))
		if data.get_custom_data('water'):
			#print('I am water.')
			#data.set_custom_data('test')
			pass
		elif data.get_custom_data('land'):
			gridData[clicked_cell].isOccupied = true
			tile_map.set_cell(clicked_cell, source_id, tree_atlas)
			tree_counter = tree_counter + 1
			rich_text_label.clear()
			rich_text_label.bbcode_enabled = true
			rich_text_label.append_text("[center]Trees:\n " + str(tree_counter) + "[/center]")
			
			
		return data.get_custom_data("water")
	else:
		return 0

func _process(delta: float) -> void:
	
	
	if Globals.game_started == false and Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if is_instance_valid(intro):
			intro.queue_free()
		Globals.game_started = true
		canvas_layer.visible = true
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		get_clicked_tile_power()
		


func _on_button_pressed() -> void:
	reset_world()
	pass # Replace with function body.

func create_obj():
	var newObj = SPAWN.instantiate()
	return newObj

	
	
