extends Timer

const BulletScene := preload("res://scenes/bullet.tscn")

enum BulletType {
	PLAYER_FORWARD,
	ENEMY_TARGET_PLAYER,
}

@export var bullet_type: BulletType = BulletType.PLAYER_FORWARD
@export var speed: float
@export var spread: float
@export var offset: float
@export_range(1, 20) var count := 1

@onready var source_node := get_parent() as Node3D


func _ready() -> void:
	assert(source_node)
	timeout.connect(_shoot)


func _shoot() -> void:
	var is_enemy_bullet := false
	var direction := Vector3.ZERO

	match bullet_type:
		BulletType.PLAYER_FORWARD:
			direction = Vector3.FORWARD
		BulletType.ENEMY_TARGET_PLAYER:
			is_enemy_bullet = true
			if mgmt.player:
				direction = (mgmt.player.position - source_node.position).normalized()

	if direction == Vector3.ZERO:
		return

	var position := source_node.global_position
	var velocity := direction * speed

	if count == 1:
		_spawn_bullet(position, velocity, is_enemy_bullet)
	else:
		for i in range(count):
			_spawn_bullet(
				position + Vector3((2.0 * offset / (count - 1) * i - offset), 0, 0),
				velocity.rotated(
					Vector3.UP,
					(2.0 * spread / (count - 1) * i - spread)
				),
				is_enemy_bullet
			)


func _spawn_bullet(position: Vector3, velocity: Vector3, is_enemy_bullet: bool) -> void:
	if mgmt.world:
		var bullet := BulletScene.instantiate()
		mgmt.world.add_child(bullet)
		velocity.y = 0
		bullet.setup(position, velocity, is_enemy_bullet)
