extends Camera2D

var speed = -1.45
var scale_value = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		position += event.velocity * get_process_delta_time() * speed
	
	if event is InputEventMouseButton and event.button_index == 4:
		print(event)
		if zoom.x < 4:
			# zoom += Vector2(scale_value, scale_value)
			print("origin ", position, " ", zoom)
			print("mouse ", get_global_mouse_position())
			var initial_zoom = zoom
			zoom += Vector2(scale_value, scale_value) 
			print("offset: ", position - get_global_mouse_position())			
			position += (position - get_global_mouse_position()) * (Vector2.ONE- zoom/initial_zoom) 
			print("final ", position, " ", zoom)

		if zoom.x > 4:
			zoom = Vector2.ONE * 4
	if event is InputEventMouseButton and event.button_index == 5 and event.is_pressed():
		print(event)
		if zoom.x > 0.4:
			print("origin ", position, " ", zoom)
			print("mouse ", get_global_mouse_position())
			var initial_zoom = zoom
			zoom -= Vector2(scale_value, scale_value) 
			print("offset: ", position - get_global_mouse_position())			
			position += (position - get_global_mouse_position()) * (Vector2.ONE- zoom/initial_zoom) 
			print("final ", position, " ", zoom)
