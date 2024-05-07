extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")


const MOVE_INPUT_SCALE := Vector2(3.0, 3.0)
const MOVE_LERP_BASE := 0.3
const MOVE_LERP_SCALE := 8.0


@export var bullet_speed := 20.0


func _ready() -> void:
	HitBox.new(hit).trait_attach(self)


func get_input_vector() -> Vector2:
	return Input.get_vector("player_left", "player_right", "player_up", "player_down")


func _physics_process(delta: float) -> void:
	var target_velocity := get_input_vector() * MOVE_INPUT_SCALE
	var weight = pow(MOVE_LERP_BASE, delta * MOVE_LERP_SCALE)
	velocity.x = lerpf(target_velocity.x, velocity.x, weight)
	velocity.z = lerpf(target_velocity.y, velocity.z, weight)
	move_and_slide()


func hit() -> void:
	print("hit")


func _on_bullet_timer_timeout() -> void:
	var p := position + Vector3.FORWARD * 1.0
	var v := Vector3.FORWARD * bullet_speed
	spawn_bullet(p + Vector3.LEFT * 0.1, v)
	spawn_bullet(p + Vector3.RIGHT * 0.1, v)


func spawn_bullet(p: Vector3, v: Vector3) -> void:
	var bullet := BulletScene.instantiate()
	get_parent().add_child(bullet)
	bullet.setup(p, v, false)

