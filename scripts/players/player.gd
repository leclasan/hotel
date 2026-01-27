extends Node2D

@export var player_index: int = 1

enum States {NORMAL, DRAGGING, GUESTSCORE, UPGRADING, NOT_PLAYING}
var state = States.NOT_PLAYING

var money = 10

#signal room_selected
#signal yes_no_button_pressed

@onready var guest_position_1: Marker2D = $GuestPosition1
@onready var guest_position_2: Marker2D = $GuestPosition2
@onready var buyer_position_1: Marker2D = $BuyerPosition1
@onready var buyer_position_2: Marker2D = $BuyerPosition2
@onready var buyer_position_3: Marker2D = $BuyerPosition3
@onready var money_label: Label = $Control/MoneyLabel
@onready var action_label: Label = $Control/ActionLabel
@onready var guest_score_panel: Panel = $GuestScorePanel
@onready var guest_score_position: Marker2D = $GuestScorePanel/GuestScorePosition
@onready var yes_button: Button = $GuestScorePanel/YesButton
@onready var no_button: Button = $GuestScorePanel/NoButton
@onready var room_cards: Node2D = $SubViewportContainer/CardViewport/RoomCards


var guest_1
var guest_2

var turns = 0
var actions = 0

var if_score_guest = true
var occupied_room

func _ready() -> void:
	money_label.text = "Money: " + str(money)
	action_label.text = "Actions: " + str(actions)
	get_parent().next_round.connect(next_round)
	create_guests()
	create_buyers()


func _process(_delta: float) -> void:
	money_label.text = "Money: " + str(money)
	action_label.text = "Actions: " + str(actions)


func _on_next_turn_button_pressed() -> void:
	if state == States.NORMAL:
		turns += 1
		state = States.NOT_PLAYING
		get_parent().next_turn(self)

#func punctuate_guest(guest_number):
	#prepare_guest_score_panel(true)
	#state = States.GUESTSCORE
	#if guest_number == 1:
		#await score_guest(guest_1)
	#elif guest_number == 2:
		#await score_guest(guest_2)
	#prepare_guest_score_panel(false)
	#state = States.NORMAL

func create_guests():
	var guest_1_scene = get_parent().round_guest_list.get(0).instantiate()
	var guest_2_scene = get_parent().round_guest_list.get(1).instantiate()
	guest_1_scene.position = guest_position_1.position
	guest_2_scene.position = guest_position_2.position
	guest_1_scene.index = 1
	guest_2_scene.index = 2
	add_child(guest_1_scene)
	add_child(guest_2_scene)

func eliminate_guests():
	guest_1.queue_free()
	guest_2.queue_free()

func create_buyers():
	var buyer_1_scene = get_parent().round_buyer_list.get(0).instantiate()
	var buyer_2_scene = get_parent().round_buyer_list.get(1).instantiate()
	var buyer_3_scene = get_parent().round_buyer_list.get(2).instantiate()
	buyer_1_scene.position = buyer_position_1.position
	buyer_2_scene.position = buyer_position_2.position
	buyer_3_scene.position = buyer_position_3.position
	add_child(buyer_1_scene)
	add_child(buyer_2_scene)
	add_child(buyer_3_scene)

func eliminate_buyers():
	for buyer in get_tree().get_nodes_in_group("buyers"):
		if get_children().has(buyer):
			buyer.queue_free()

#func score_guest(guest):
	#guest.position = guest_score_position.position
	#see_if_score_guest(guest)
	#if if_score_guest:
		#prepare_guest_score_button(true)
		#await yes_no_button_pressed
		#prepare_guest_score_button(false)
		#if if_score_guest:
			#await place_guest(guest)
			#money += guest.money
	#guest.queue_free()
#
#func place_guest(guest):
	#if guest.room_1 == "room":
		#for room in get_tree().get_nodes_in_group("room_cards"):
			#room.state = room.States.GUESTSCORE
		#await room_selected
		#occupied_room.rounds_occupied = guest.rounds_occupied 
		#for room in get_tree().get_nodes_in_group("room_cards"):
			#room.state = room.States.POSITIONED
	#if guest.room_2 == "room":
		#for room in get_tree().get_nodes_in_group("room_cards"):
			#room.state = room.States.GUESTSCORE
		#await room_selected
		#occupied_room.rounds_occupied = guest.rounds_occupied 
		#for room in get_tree().get_nodes_in_group("room_cards"):
			#room.state = room.States.POSITIONED
	#if guest.room_3 == "room":
		#for room in get_tree().get_nodes_in_group("room_cards"):
			#room.state = room.States.GUESTSCORE
		#await room_selected
		#occupied_room.rounds_occupied = guest.rounds_occupied 
		#for room in get_tree().get_nodes_in_group("room_cards"):
			#room.state = room.States.POSITIONED
	#if guest.room_1 == "hallway":
		#for room in get_tree().get_nodes_in_group("hallway_cards"):
			#room.state = room.States.GUESTSCORE
		#await room_selected
		#occupied_room.rounds_occupied = guest.rounds_occupied 
		#for room in get_tree().get_nodes_in_group("hallway_cards"):
			#room.state = room.States.POSITIONED
	#if guest.room_2 == "hallway":
		#for room in get_tree().get_nodes_in_group("hallway_cards"):
			#room.state = room.States.GUESTSCORE
		#await room_selected
		#occupied_room.rounds_occupied = guest.rounds_occupied 
		#for room in get_tree().get_nodes_in_group("hallway_cards"):
			#room.state = room.States.POSITIONED
	#if guest.room_3 == "hallway":
		#for room in get_tree().get_nodes_in_group("hallway_cards"):
			#room.state = room.States.GUESTSCORE
		#await room_selected
		#occupied_room.rounds_occupied = guest.rounds_occupied 
		#for room in get_tree().get_nodes_in_group("hallway_cards"):
			#room.state = room.States.POSITIONED
#
#func place_guest_extra(guest):
	#pass
#
#func select_room(node):
	#node.animation_player.play("occupied")
	#node.is_occupied = true
	#money += node.level -1
	#occupied_room = node
	#room_selected.emit()
#
#func prepare_guest_score_panel(on: bool):
	#guest_score_panel.visible = on
#
#func prepare_guest_score_button(on: bool):
	#yes_button.visible = on
	#no_button.visible = on
	#yes_button.disabled = not on
	#no_button.disabled = not on
#
#func see_if_score_guest(guest) -> void:
	#var card_nodes_in_tree: Array = room_cards.get_children()
	#if guest.room_1 == "room":
		#var ok = false
		#for node in card_nodes_in_tree:
			#if node.is_in_group("room_cards") and not node.is_occupied:
				#ok = true
				#card_nodes_in_tree.erase(node)
				#break
		#if not ok:
			#if_score_guest = false
			#return
	#if guest.room_2 == "room":
		#var ok = false
		#for node in card_nodes_in_tree:
			#if node.is_in_group("room_cards") and not node.is_occupied:
				#ok = true
				#card_nodes_in_tree.erase(node)
				#break
		#if not ok:
			#if_score_guest = false
			#return
	#if guest.room_3 == "room":
		#var ok = false
		#for node in card_nodes_in_tree:
			#if node.is_in_group("room_cards") and not node.is_occupied:
				#ok = true
				#card_nodes_in_tree.erase(node)
				#break
		#if not ok:
			#if_score_guest = false
			#return
	#if guest.room_1 == "hallway":
		#var ok = false
		#for node in card_nodes_in_tree:
			#if node.is_in_group("hallway_cards") and not node.is_occupied:
				#ok = true
				#card_nodes_in_tree.erase(node)
				#break
		#if not ok:
			#if_score_guest = false
			#return
	#if guest.room_2 == "hallway":
		#var ok = false
		#for node in card_nodes_in_tree:
			#if node.is_in_group("hallway_cards") and not node.is_occupied:
				#ok = true
				#card_nodes_in_tree.erase(node)
				#break
		#if not ok:
			#if_score_guest = false
			#return
	#if guest.room_3 == "hallway":
		#var ok = false
		#for node in card_nodes_in_tree:
			#if node.is_in_group("hallway_cards") and not node.is_occupied:
				#ok = true
				#card_nodes_in_tree.erase(node)
				#break
		#if not ok:
			#if_score_guest = false
			#return
	#if_score_guest = true
	#
#func _on_yes_no_button_pressed(yes: bool):
	#if_score_guest = yes
	#yes_no_button_pressed.emit()

func next_round():
	actions = 0
	turns = 0
	eliminate_buyers()
	eliminate_guests()
	create_buyers()
	create_guests()
#
