extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

@export var target_path: NodePath
@export var range := 1.0
@export var speed := 0.001
@export var bullet_speed := 3.0

@onready var target_node := get_node(target_path) as Node3D

func _ready() -> void:
	assert(target_node)

func _physics_process(delta: float) -> void:
	position.x = range * sin(Time.get_ticks_msec() * speed)


func _on_bullet_timer_timeout() -> void:
	var velocity := (target_node.position - position).normalized() * bullet_speed
	spawn_bullet(velocity)
	spawn_bullet(velocity.rotated(Vector3.UP, 0.1))
	spawn_bullet(velocity.rotated(Vector3.UP, -0.1))

func spawn_bullet(velocity: Vector3) -> void:
	var bullet := BulletScene.instantiate()
	get_parent().add_child(bullet)
	velocity.y = 0
	bullet.setup(position, velocity, true)
