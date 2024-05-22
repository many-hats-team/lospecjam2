class_name PlayerUi
extends Node2D

const COUNT_DIGITS := 6
const COUNT_PIPS := 8

var score := 0:
	set(value):
		score = value
		for i in range(COUNT_DIGITS):
			_digits[i].frame = posmod(value, 10)
			value /= 10

var lives := COUNT_PIPS:
	set(value):
		lives = value
		for i in range(COUNT_PIPS):
			_pips[i].visible = i < lives


@onready var _digits := util.multidup(%Digit, COUNT_DIGITS, -8.0)
@onready var _pips := util.multidup(%Pip, COUNT_PIPS, -6.0)


func _ready() -> void:
	mgmt.player_ui = self

