class_name EnemySpawner
extends Marker3D

const CarScene := preload("res://scenes/objects/car.tscn")
const BikerScene := preload("res://scenes/objects/biker.tscn")

enum Kind {
	CAR,
	BIKER,
}

@export var kind: Kind

@export var speed: float
@export var offset: float
@export var wait_min: float
@export var wait_max: float

@onready var rng := RandomNumberGenerator.new()

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	timer.autostart = true
	timer.timeout.connect(_on_timeout)
	mgmt.boss_died.connect(timer.stop)
	_pick_new_wait_time()
	add_child(timer)


func _pick_new_wait_time() -> void:
	timer.wait_time = rng.randf_range(wait_min, wait_max)


func _on_timeout() -> void:
	_pick_new_wait_time()

	var world := mgmt.get_world()
	if world:
		var enemy: Node3D
		match kind:
			Kind.CAR:
				enemy = CarScene.instantiate()
			Kind.BIKER:
				enemy = BikerScene.instantiate()
		enemy.position = global_position + Vector3(rng.randf_range(-offset, offset), 0, 0)
		world.add_child(enemy)
