class_name MainMenu
extends Node

signal game_started


@onready var start_btn := %StartButton as Button


func _ready() -> void:
	assert(start_btn)
	start_btn.grab_focus()


func _on_start_button_pressed() -> void:
	game_started.emit()


func _on_quit_button_pressed() -> void:
	mgmt.quit()
