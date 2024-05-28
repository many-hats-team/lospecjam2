class_name LockY
extends Node

@onready var node := get_parent() as Node3D

var y := 0.0

func _ready() -> void:
	assert(node)
	y = node.position.y

func _physics_process(_delta: float) -> void:
	node.position.y = y
