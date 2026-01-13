extends Area2D

var guest_name = "Pig"

var room_1 = "room"
var room_2 = "hallway"
var room_3 = ""
var extra_room_1 = ""
var extra_room_2 = ""
var extra_room_3 = ""
var rounds_occupied = 2
var money = 7

var index = 1

func _ready() -> void:
	if index == 1:
		get_parent().guest_1 = self
	elif index == 2:
		get_parent().guest_2 = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
