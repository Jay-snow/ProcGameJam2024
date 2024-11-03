extends Camera2D

var threshold = 100
var step = 2



func _process(delta):
	
	if Globals.game_started == false:
		return
	
	var viewport_size = get_viewport().size
	var local_mouse_pos = get_local_mouse_position()
	#print(get_viewport().size)
	#print(viewport_size.x)
	print(position)
	if local_mouse_pos.x < threshold:
		if position.x > -1:
			position.x -= step
		
	elif local_mouse_pos.x > viewport_size.x - threshold:
		
		position.x += step
	if local_mouse_pos.y < threshold:
		if position.y > -1:
			position.y -= step
	elif local_mouse_pos.y > viewport_size.y - threshold:
		position.y += step
