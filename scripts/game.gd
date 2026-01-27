extends Node

var player_preload = preload("res://scenes/players/player.tscn")
@export var number_of_players = 2
var player_list: Array = []

var all_buyers_list = [preload("res://scenes/cards/buyers/room_buyer.tscn"), preload("res://scenes/cards/buyers/hallway_buyer.tscn")]
@onready var round_buyer_list: Array = [all_buyers_list.pick_random(), all_buyers_list.pick_random(), all_buyers_list.pick_random()]

var all_guest_list = [preload("res://scenes/persons/person_1.tscn"), preload("res://scenes/persons/person_2.tscn"), preload("res://scenes/persons/person_3.tscn")]
@onready var round_guest_list: Array = [all_guest_list.pick_random(), all_guest_list.pick_random()]

signal next_round

func _ready() -> void:
	for player_x in number_of_players:
		var player_instance = player_preload.instantiate()
		player_instance.name = "Player" + str(player_x + 1)
		player_instance.player_index = player_x + 1
		if player_x == 0:
			player_instance.state = player_instance.States.NORMAL
			player_instance.show()
		add_child(player_instance)
		player_list.push_back(get_node("Player" + str(player_x + 1)))
		print(player_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func next_turn(current_player):
	current_player.hide()
	var next_player_list_number = player_list.find(current_player) + 1
	if next_player_list_number >= number_of_players:
		next_round_function()
		next_player_list_number = 0
	var next_player = player_list.get(next_player_list_number )
	next_player.show()
	next_player.state = next_player.States.NORMAL

func next_round_function():
	round_buyer_list = [all_buyers_list.pick_random(), all_buyers_list.pick_random(), all_buyers_list.pick_random()]
	round_guest_list = [all_guest_list.pick_random(), all_guest_list.pick_random()]
	next_round.emit()
