extends Node2D

class_name BasicRoom

@onready var door_area: Area2D = $DoorArea
@onready var wall_area: Area2D = $WallArea
@onready var center_area: Area2D = $CenterArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_occupied = false
var rounds_occupied = 0

enum States {DRAGGABLE, POSITIONED, GUESTSCORE}
var state = States.DRAGGABLE

var is_mouse = true

func _ready() -> void:
	top_level = true
	PlayerStats.state = PlayerStats.States.DRAGGING
	get_parent().next_round.connect(next_round)

func _process(delta: float) -> void:
	match state:
		States.DRAGGABLE:
			move()
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and check_connections():
				state = States.POSITIONED
				PlayerStats.state = PlayerStats.States.NORMAL
				animation_player.play("normal")
				top_level = false
			elif Input.is_action_just_pressed("right_click"):
				rotate(PI/2)
				if rotation > 2*PI:
					rotation = 0.0
				print(rotation)
		States.POSITIONED:
			pass
		States.GUESTSCORE:
			pass

func check_connections():
	var is_ok = false
	for area in door_area.get_overlapping_areas():
		if area.is_in_group("walls"):
			return false
		elif area.is_in_group("doors"):
			is_ok = true
	for area in wall_area.get_overlapping_areas():
		if area.is_in_group("doors"):
			return false
	for area in center_area.get_overlapping_areas():
		if area.is_in_group("center"):
			return false
	if is_ok:
		return true
	return false

func move():
	position = Vector2(int((get_global_mouse_position().x+64)/128) * 128, int((get_global_mouse_position().y+64)/128) * 128)
	if check_connections():
		animation_player.play("green")
	else:
		animation_player.play("red")

func next_round():
	if is_occupied:
		if rounds_occupied > 0:
			rounds_occupied -= 1
		elif rounds_occupied <= 0:
			rounds_occupied = 0
			is_occupied = false
			animation_player.play("normal")



func _on_mouse_detect_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if state == States.GUESTSCORE and not is_occupied and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		get_parent().select_room(self)
