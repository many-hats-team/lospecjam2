extends MeshInstance3D

const SHRINK_TIME_S := 1.0

var velocity: Vector3
var ground_height: float

@onready var raycast := %Raycast3D as RayCast3D
@onready var radius: float = mesh.radius

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
	assert(radius > 0.0)

func _physics_process(delta: float) -> void:
	raycast.target_position = velocity * delta + velocity.normalized() * radius
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
