class_name BossUi
extends Node2D

const COUNT_PIPS := 6

var lives := COUNT_PIPS:
	set(value):
		lives = value
		for i in range(COUNT_PIPS):
			_pips[i].visible = i < lives


@onready var _pips := util.multidup(%Pip, COUNT_PIPS, 8.0)


func _ready() -> void:
	visible = false
	mgmt.boss_spawned.connect(_on_spawned)
	mgmt.boss_health_changed.connect(_on_health_changed)


func _on_spawned() -> void:
	visible = true


func _on_health_changed(hp: int) -> void:
	for i in range(COUNT_PIPS):
		_pips[i].visible = i < hp
