class_name Player
extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")


const MOVE_INPUT_SCALE := Vector2(3.0, 3.0)
const MOVE_LERP_BASE := 0.3
const MOVE_LERP_SCALE := 8.0


func _ready() -> void:
	HitBox.new(hit).trait_attach(self)
	mgmt.player = self


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

