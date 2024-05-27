class_name Player
extends CharacterBody3D

const MOVE_INPUT_SCALE := Vector2(3.0, 3.0)
const MOVE_LERP_BASE := 0.3
const MOVE_LERP_SCALE := 8.0

const SPRITE_HORIZONTAL_DEADZONE := 1.0

const HIT_PAUSE_DURATION_S := 0.3
const CRASH_POSITION_Z := 5.0
const CRASH_DURATION_S := 1.0
const RECOVER_POSITION_Z := 3.0
const RECOVER_DURATION_S := 1.0
const IFRAME_DURATION_S := 2.0

@export var image_center: Image
@export var image_left: Image
@export var image_right: Image

@onready var texture_center := ImageTexture.create_from_image(image_center)
@onready var texture_left := ImageTexture.create_from_image(image_left)
@onready var texture_right := ImageTexture.create_from_image(image_right)

@onready var sprite := %Sprite as MySprite
@onready var weapon := %Weapon as Weapon

var is_input_enabled := true
var is_in_hit_animation := false

func _ready() -> void:
	assert(sprite)
	assert(weapon)
	HitBox.new(self, _on_hit)
	mgmt.set_player(self)
	sprite.texture = texture_center


func get_input_vector() -> Vector2:
	return Input.get_vector("player_left", "player_right", "player_up", "player_down")


func _physics_process(delta: float) -> void:
	if is_input_enabled:
		var target_velocity := get_input_vector() * MOVE_INPUT_SCALE
		var weight = pow(MOVE_LERP_BASE, delta * MOVE_LERP_SCALE)
		velocity.x = lerpf(target_velocity.x, velocity.x, weight)
		velocity.z = lerpf(target_velocity.y, velocity.z, weight)

		if velocity.x > SPRITE_HORIZONTAL_DEADZONE:
			sprite.texture = texture_right
		elif velocity.x < -SPRITE_HORIZONTAL_DEADZONE:
			sprite.texture = texture_left
		else:
			sprite.texture = texture_center

		move_and_slide()


func _on_hit() -> void:
	if is_in_hit_animation:
		return

	mgmt.add_life(-1)

	is_in_hit_animation = true
	is_input_enabled = false
	weapon.stop()

	# Short pause and flash
	sprite.set_flash(true)
	mgmt.pause()
	await get_tree().create_timer(HIT_PAUSE_DURATION_S).timeout
	mgmt.unpause()
	sprite.set_flash(false)

	# Fall off screen and recover
	var tween := create_tween()
	tween\
		.tween_property(self, "position:z", CRASH_POSITION_Z, CRASH_DURATION_S)\
		.set_trans(Tween.TRANS_SINE)
	tween\
		.tween_property(self, "position:z", RECOVER_POSITION_Z, RECOVER_DURATION_S)\
		.set_trans(Tween.TRANS_SINE)
	await tween.finished

	# Regain control
	weapon.start()
	is_input_enabled = true

	# I-frames
	await sprite.blink(IFRAME_DURATION_S)

	is_in_hit_animation = false
