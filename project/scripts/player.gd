class_name Player
extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

const MOVE_INPUT_SCALE := Vector2(3.0, 3.0)
const MOVE_LERP_BASE := 0.3
const MOVE_LERP_SCALE := 8.0

const SPRITE_HORIZONTAL_DEADZONE := 1.0


@export var image_center: Image
@export var image_left: Image
@export var image_right: Image

@onready var texture_center := ImageTexture.create_from_image(image_center)
@onready var texture_left := ImageTexture.create_from_image(image_left)
@onready var texture_right := ImageTexture.create_from_image(image_right)

@onready var sprite := %Sprite as MySprite


func _ready() -> void:
	assert(sprite)
	HitBox.new(self, hit)
	mgmt.player = self
	sprite.texture = texture_center


func get_input_vector() -> Vector2:
	return Input.get_vector("player_left", "player_right", "player_up", "player_down")


func _physics_process(delta: float) -> void:
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


func hit() -> void:
	sprite.hit_flash()
