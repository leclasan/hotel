extends PanelContainer

var opacity_tween: Tween = null

var first_time = false

@onready var tooltip_text_node: RichTextLabel = $VBoxContainer/TooltipText

func tween_opacity(to: float):
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.3)
	return opacity_tween

func _on_mouse_detect_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not first_time and event is InputEventMouseButton and event.button_index == 1 and event.pressed and PlayerStats.state == PlayerStats.States.NORMAL:
		first_time = true
		return
	elif event is InputEventMouseButton and event.button_index == 1 and event.pressed and PlayerStats.state == PlayerStats.States.NORMAL:
		PlayerStats.state = PlayerStats.States.UPGRADING
		tooltip_text_node.text = "Level " + str(get_parent().level) + "[br] Upgrade?[br] Cost:" + str(2*get_parent().level)
		position = get_parent().position
		position.x -= 114
		show()
		modulate.a = 0.0
		tween_opacity(1.0)

func _on_upgrade_no_button_pressed():
	if visible:
		modulate.a = 1.0
		await tween_opacity(0.0).finished
		hide()
		PlayerStats.state = PlayerStats.States.NORMAL

func _on_upgrade_yes_button_pressed() -> void:
	if visible:
		if PlayerStats.money >= 2 * get_parent().level:
			PlayerStats.money -= 2 * get_parent().level
			get_parent().level += 1
			get_parent().total_parent.actions += 1
			modulate.a = 1.0
			await tween_opacity(0.0).finished
			hide()
			PlayerStats.state = PlayerStats.States.NORMAL
