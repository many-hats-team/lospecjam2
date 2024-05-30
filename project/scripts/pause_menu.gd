class_name PauseMenu
extends Control


@onready var continue_button := %ContinueButton as Button
@onready var restart_button := %RestartButton as Button
@onready var label := %Label as Label


var is_game_over := false


func _ready() -> void:
	assert(continue_button)
	assert(label)

	visible = false
	mgmt.game_over_win.connect(_on_game_over_win)
	mgmt.game_over_lose.connect(_on_game_over_lose)


func _process(_delta: float) -> void:
	if not is_game_over and Input.is_action_just_pressed("player_start"):
		toggle()


func _on_game_over_win() -> void:
	label.text = "Well done"
	_on_game_over()


func _on_game_over_lose() -> void:
	label.text = "GAME OVER"
	_on_game_over()


func _on_game_over() -> void:
	is_game_over = true
	continue_button.visible = false
	open()


func toggle() -> void:
	if visible:
		close()
	else:
		open()


func open() -> void:
	if visible:
		assert(false)
		return

	# Let animation-pauses complete
	await mgmt.wait_until_unpause()

	visible = true
	if continue_button.visible:
		continue_button.grab_focus()
	else:
		restart_button.grab_focus()
	mgmt.pause()


func close() -> void:
	if not visible:
		assert(false)
		return

	visible = false
	mgmt.unpause()


func _on_continue_button_pressed() -> void:
	close()


func _on_quit_button_pressed() -> void:
	close()
	mgmt.quit()


func _on_main_menu_button_pressed() -> void:
	close()
	mgmt.quit_to_main_menu.emit()


func _on_restart_button_pressed() -> void:
	close()
	mgmt.restart_requested.emit()
