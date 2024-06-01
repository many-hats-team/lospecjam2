class_name MainMenu
extends Node

signal game_started


@onready var title := %Title as Sprite2D
@onready var howto := %HowToPlay as Sprite2D
@onready var start_btn := %StartButton as Button


func _ready() -> void:
	assert(title)
	assert(howto)
	assert(start_btn)

	title.visible = true
	howto.visible = false

	start_btn.grab_focus()


func _on_start_button_pressed() -> void:
	game_started.emit()


func _on_quit_button_pressed() -> void:
	mgmt.quit()


func _on_how_to_play_button_pressed() -> void:
	title.visible = not title.visible
	howto.visible = not howto.visible
