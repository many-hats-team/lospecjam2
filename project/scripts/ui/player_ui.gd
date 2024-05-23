class_name PlayerUi
extends Node2D

const COUNT_DIGITS := 6
const COUNT_PIPS := 8


@onready var _digits := util.multidup(%Digit, COUNT_DIGITS, -8.0)
@onready var _pips := util.multidup(%Pip, COUNT_PIPS, -6.0)


func _ready() -> void:
	_on_lives_changed(mgmt.player_lives)
	mgmt.player_lives_changed.connect(_on_lives_changed)

	_on_score_changed(mgmt.score)
	mgmt.score_changed.connect(_on_score_changed)


func _on_lives_changed(lives: int) -> void:
	for i in range(COUNT_PIPS):
		_pips[i].visible = i < lives


func _on_score_changed(score: int) -> void:
	for i in range(COUNT_DIGITS):
		_digits[i].frame = posmod(score, 10)
		score /= 10
