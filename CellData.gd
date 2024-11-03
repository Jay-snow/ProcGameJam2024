extends Node

class_name CellData

var isOccupied : bool = false
var type : Vector2i



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_type(type)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_type(value) -> void:
	type = value
	#print('type set!')

func get_north_cell(my_position: Vector2i) -> Vector2i:
	#print(type_string(typeof(my_position)))
	return Vector2i(my_position.x, my_position.y - 1)
	
	
