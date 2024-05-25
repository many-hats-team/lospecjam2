extends MeshInstance3D

const SHRINK_TIME_S := 1.0
const COL_MASK_ENEMY_BULLET := 0b011
const COL_MASK_PLAYER_BULLET := 0b101

var velocity := Vector3.ZERO:
	set(v):
		velocity = v
		if v:
			look_at(position + v)

var ground_height: float

@onready var raycast := %Raycast3D as RayCast3D

func setup(pos: Vector3, vel: Vector3, is_enemy_bullet: bool, mesh_: Mesh) -> void:
	position = pos
	velocity = vel

	if is_enemy_bullet:
		# target player
		raycast.collision_mask = COL_MASK_ENEMY_BULLET
	else:
		# target enemy
		raycast.collision_mask = COL_MASK_PLAYER_BULLET

	mesh = mesh_

func _ready() -> void:
	assert(raycast)

func _physics_process(delta: float) -> void:
	raycast.target_position = (
		velocity * delta + velocity.normalized() * MeshGen.SCALE
	)
	var collider := raycast.get_collider()
	if collider:
		queue_free()
		var hb := HitBox.trait_get(collider)
		if hb:
			hb.hit()

	position += velocity * delta

func _on_death_timer_timeout() -> void:
	#var tw := create_tween()
	#tw.tween_property(self, "scale", Vector3.ZERO, SHRINK_TIME_S)
	#await tw.finished
	queue_free()
	visible = false


func is_enemy_bullet() -> bool:
	return raycast.collision_mask == COL_MASK_ENEMY_BULLET
