extends Area2D

var cost = 5

var room_scene = preload("res://scenes/cards/rooms/hallway_card.tscn")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and PlayerStats.state == PlayerStats.States.NORMAL and event.is_released():
		if PlayerStats.money >= cost:
			PlayerStats.state = PlayerStats.States.DRAGGING
			PlayerStats.money -= cost
			var room = room_scene.instantiate()
			room.position = get_global_mouse_position()
			get_parent().room_cards.add_child(room)
