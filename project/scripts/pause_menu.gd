class_name PauseMenu
extends Control


@onready var continue_button := %ContinueButton as Button


func _ready() -> void:
	assert(continue_button)
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_start"):
		toggle()


func toggle() -> void:
	if visible:
		close()
	else:
		open()


func open() -> void:
	# Let animation-pauses complete
	await mgmt.wait_until_unpause()

	visible = true
	continue_button.grab_focus()
	mgmt.pause()


func close() -> void:
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
