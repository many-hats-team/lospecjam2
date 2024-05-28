extends Timer


const BossScene := preload("res://scenes/objects/boss.tscn")

@onready var parent := get_parent() as Node3D


func _ready() -> void:
	assert(parent)
	timeout.connect(spawn_boss)


func spawn_boss() -> void:
	var world := mgmt.get_world()
	assert(world)

	var boss := BossScene.instantiate() as Boss
	assert(boss)

	world.add_child(boss)
	boss.position = parent.position
