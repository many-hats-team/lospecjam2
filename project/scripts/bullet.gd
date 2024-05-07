extends Node3D

var velocity: Vector3

@onready var raycast := %Raycast3D as RayCast3D

func setup(pos: Vector3, vel: Vector3, is_enemy_bullet: bool) -> void:
	position = pos
	velocity = vel
	if is_enemy_bullet:
		# target player
		raycast.collision_mask = 0b011
	else:
		# target enemy
		raycast.collision_mask = 0b101

func _ready() -> void:
	assert(raycast)

func _process(delta: float) -> void:
	position += velocity * delta

func _physics_process(delta: float) -> void:
	raycast.target_position = velocity * delta + velocity.normalized() * scale.x
	var collider := raycast.get_collider()
	if collider:
		queue_free()
		var hb := HitBox.trait_get(collider)
		if hb:
			hb.hit()

func _on_death_timer_timeout() -> void:
	queue_free()
