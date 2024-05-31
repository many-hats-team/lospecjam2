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

const WIN_DELAY_S := 1.0
const WIN_POSITION_Z := -50.0
const WIN_DURATION_S := 5.0

@export var image_center: Image
@export var image_left: Image
@export var image_right: Image

@onready var texture_center := ImageTexture.create_from_image(image_center)
@onready var texture_left := ImageTexture.create_from_image(image_left)
@onready var texture_right := ImageTexture.create_from_image(image_right)

@onready var sprite := %Sprite as MySprite
@onready var weapon := %Weapon as Weapon
@onready var damage_effect := %DamageEffect as DamageEffect

var is_input_enabled := true
var is_in_hit_animation := false
var is_game_over := false

func _ready() -> void:
	assert(sprite)
	assert(weapon)
	assert(damage_effect)

	HitBox.new(self, _on_hit)
	mgmt.set_player(self)
	sprite.texture = texture_center

	mgmt.boss_died.connect(_on_boss_died)
	mgmt.boss_removed.connect(_on_boss_removed)


func get_input_vector() -> Vector2:
	return Input.get_vector("player_left", "player_right", "player_up", "player_down")


func _physics_process(delta: float) -> void:
	if is_input_enabled and not is_game_over:
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
	if is_in_hit_animation or is_game_over:
		return

	mgmt.add_life(-1)

	is_in_hit_animation = true
	is_input_enabled = false
	weapon.stop()
	damage_effect.start()

	# Short pause and flash
	sprite.set_flash(true)
	mgmt.pause()
	await mgmt.unpausable_timer(HIT_PAUSE_DURATION_S).timeout
	mgmt.unpause()
	sprite.set_flash(false)

	# Fall off screen
	await create_tween()\
		.tween_property(self, "position:z", CRASH_POSITION_Z, CRASH_DURATION_S)\
		.set_trans(Tween.TRANS_SINE)\
		.finished

	# Reset position
	velocity = Vector3.ZERO
	position.x = 0.0
	sprite.texture = texture_center

	if mgmt.state.player_lives <= 0:
		mgmt.game_over_lose.emit()
		return

	# Come back on screen
	await create_tween()\
		.tween_property(self, "position:z", RECOVER_POSITION_Z, RECOVER_DURATION_S)\
		.set_trans(Tween.TRANS_SINE)\
		.finished

	# Regain control
	weapon.start()
	is_input_enabled = true

	# I-frames
	await sprite.blink(IFRAME_DURATION_S)

	is_in_hit_animation = false


func _on_boss_died() -> void:
	is_game_over = true
	sprite.texture = texture_center
	# disable collision
	collision_mask = 0
	collision_layer = 0


func _on_boss_removed() -> void:
	# wait until any hit animation is done
	while is_in_hit_animation:
		await get_tree().process_frame

	await mgmt.pausable_timer(WIN_DELAY_S).timeout

	await create_tween()\
		.tween_property(self, "position:z", WIN_POSITION_Z, WIN_DURATION_S)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_LINEAR)\
		.finished

	mgmt.game_over_win.emit()
