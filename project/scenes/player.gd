extends CharacterBody3D


const MOVE_INPUT_SCALE := Vector2(5.0, 5.0)
const MOVE_LERP_BASE := 0.3
const MOVE_LERP_SCALE := 100.0


func get_input_vector() -> Vector2:
	return Input.get_vector("player_left", "player_right", "player_up", "player_down")


func _physics_process(delta: float) -> void:
	var target_velocity := get_input_vector() * MOVE_INPUT_SCALE

	var weight = pow(MOVE_LERP_BASE, delta * MOVE_LERP_SCALE)

	velocity.x = lerpf(velocity.x, target_velocity.x, weight)
	velocity.z = lerpf(velocity.z, target_velocity.y, weight)
	move_and_slide()
