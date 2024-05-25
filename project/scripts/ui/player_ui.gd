class_name PlayerUi
extends Node2D

const COUNT_DIGITS := 6
const COUNT_PIPS := 8


@onready var _digits := util.multidup(%Digit, COUNT_DIGITS, -8.0)
@onready var _pips := util.multidup(%Pip, COUNT_PIPS, -6.0)


var display_score := 0.0
var target_score := 0.0


func _ready() -> void:
	_on_lives_changed(mgmt.player_lives)
	mgmt.player_lives_changed.connect(_on_lives_changed)

	_on_score_changed(mgmt.score)
	mgmt.score_changed.connect(_on_score_changed)


func _process(delta: float) -> void:
	if display_score != target_score:
		display_score = util.damp(display_score, target_score, 1.0, 10.0 * delta)
		_display(int(round(display_score)))



func _on_lives_changed(lives: int) -> void:
	for i in range(COUNT_PIPS):
		_pips[i].visible = i < lives


func _on_score_changed(score: int) -> void:
	target_score = score


func _display(n: int) -> void:
	for i in range(COUNT_DIGITS):
		_digits[i].frame = posmod(n, 10)
		n /= 10
