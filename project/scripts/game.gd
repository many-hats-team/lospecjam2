class_name Game
extends Node

signal game_quit

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_start"):
		game_quit.emit()
