extends Timer

const EnemyScene := preload("res://scenes/enemy.tscn")


@export var speed: float
@export var offset: float

@onready var source_node := get_parent() as Node3D
@onready var rng := RandomNumberGenerator.new()

func _ready() -> void:
	assert(source_node)
	timeout.connect(_on_timeout)


func _on_timeout() -> void:
	var world := mgmt.get_world()
	if world:
		var enemy := EnemyScene.instantiate()
		world.add_child(enemy)
		enemy.setup(
			source_node.global_position + Vector3(rng.randf_range(-offset, offset), 0, 0),
			Vector3.BACK * speed
		)
