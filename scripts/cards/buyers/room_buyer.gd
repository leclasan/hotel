extends Area2D

var is_mouse = false

var room_scene = preload("res://scenes/cards/rooms/room_card.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and is_mouse and PlayerStats.state == PlayerStats.States.NORMAL and event.is_released():
		if PlayerStats.money >= 2:
			PlayerStats.money -= 2
			var room = room_scene.instantiate()
			room.position = get_global_mouse_position()
			add_sibling(room)
			PlayerStats.state = PlayerStats.States.DRAGGING

func _on_mouse_entered() -> void:
	is_mouse = true


func _on_mouse_exited() -> void:
	is_mouse = false
