extends Node2D

signal room_selected
signal next_round
signal yes_no_button_pressed

@onready var guest_position_1: Marker2D = $GuestPosition1
@onready var guest_position_2: Marker2D = $GuestPosition2
@onready var money_label: Label = $Control/MoneyLabel
@onready var guest_score_panel: Panel = $GuestScorePanel
@onready var guest_score_position: Marker2D = $GuestScorePanel/GuestScorePosition
@onready var yes_button: Button = $GuestScorePanel/YesButton
@onready var no_button: Button = $GuestScorePanel/NoButton

var guest_1
var guest_2

var round_count = 0

var if_score_guest = true
var occupied_room

func _ready() -> void:
	money_label.text = str(PlayerStats.money)
	create_guests()


func _process(_delta: float) -> void:
	money_label.text = str(PlayerStats.money)



func _on_next_round_button_pressed() -> void:
	if PlayerStats.state == PlayerStats.States.NORMAL:
		round_count += 1
		prepare_guest_score_panel(true)
		PlayerStats.state = PlayerStats.States.GUESTSCORE
		await score_guest(guest_1)
		await score_guest(guest_2)
		prepare_guest_score_panel(false)
		PlayerStats.state = PlayerStats.States.NORMAL
		create_guests()
		next_round.emit()


func create_guests():
	var guest_1_scene = WorldStats.guest_list.pick_random().instantiate()
	var guest_2_scene = WorldStats.guest_list.pick_random().instantiate()
	guest_1_scene.position = guest_position_1.position
	guest_2_scene.position = guest_position_2.position
	guest_1_scene.index = 1
	guest_2_scene.index = 2
	add_child(guest_1_scene)
	add_child(guest_2_scene)

func score_guest(guest):
	guest.position = guest_score_position.position
	see_if_score_guest(guest)
	if if_score_guest:
		prepare_guest_score_button(true)
		await yes_no_button_pressed
		prepare_guest_score_button(false)
		if if_score_guest:
			await place_guest(guest)
			PlayerStats.money += guest.money
	guest.queue_free()

func place_guest(guest):
	if guest.room_1 == "room":
		for room in get_tree().get_nodes_in_group("room_cards"):
			room.state = room.States.GUESTSCORE
		await room_selected
		occupied_room.rounds_occupied = guest.rounds_occupied 
		for room in get_tree().get_nodes_in_group("room_cards"):
			room.state = room.States.POSITIONED
	if guest.room_2 == "room":
		for room in get_tree().get_nodes_in_group("room_cards"):
			room.state = room.States.GUESTSCORE
		await room_selected
		occupied_room.rounds_occupied = guest.rounds_occupied 
		for room in get_tree().get_nodes_in_group("room_cards"):
			room.state = room.States.POSITIONED
	if guest.room_3 == "room":
		for room in get_tree().get_nodes_in_group("room_cards"):
			room.state = room.States.GUESTSCORE
		await room_selected
		occupied_room.rounds_occupied = guest.rounds_occupied 
		for room in get_tree().get_nodes_in_group("room_cards"):
			room.state = room.States.POSITIONED

func place_guest_extra(guest):
	pass

func select_room(node):
	node.animation_player.play("occupied")
	node.is_occupied = true
	occupied_room = node
	room_selected.emit()

func prepare_guest_score_panel(on: bool):
	guest_score_panel.visible = on

func prepare_guest_score_button(on: bool):
	yes_button.visible = on
	no_button.visible = on
	yes_button.disabled = not on
	no_button.disabled = not on

func see_if_score_guest(guest) -> void:
	var nodes_in_tree: Array = get_children()
	if guest.room_1 == "room":
		var ok = false
		for node in nodes_in_tree:
			if node.is_in_group("room_cards"):
				ok = true
				nodes_in_tree.erase(node)
				break
		if not ok:
			if_score_guest = false
			return
	if guest.room_2 == "room":
		var ok = false
		for node in nodes_in_tree:
			if node.is_in_group("room_cards"):
				ok = true
				nodes_in_tree.erase(node)
				break
		if not ok:
			if_score_guest = false
			return
	if guest.room_3 == "room":
		var ok = false
		for node in nodes_in_tree:
			if node.is_in_group("room_cards"):
				ok = true
				nodes_in_tree.erase(node)
				break
		if not ok:
			if_score_guest = false
			return
	if_score_guest = true
	
func _on_yes_no_button_pressed(yes: bool):
	if_score_guest = yes
	yes_no_button_pressed.emit()
