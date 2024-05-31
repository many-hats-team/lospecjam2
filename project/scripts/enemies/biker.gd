extends CharacterBody3D

const PickupScene := preload("res://scenes/objects/pickup.tscn")

const BIKER_HEALTH := 21
const BIKER_ENTRY_DURATION_S := 2.0
const BIKER_SCORE := 100
const BIKER_TARGET_Z_MIN := -2.0
const BIKER_TARGET_Z_MAX := 0.0
const BIKER_PICKUP_RATE := 0.3

enum Dir {
	LEFT,
	RIGHT,
}

@onready var damage_effect = %DamageEffect as DamageEffect
@onready var weapon: Weapon = %Weapon
@onready var sprite: MySprite = %Sprite
@onready var rng := RandomNumberGenerator.new()

var is_dead := false
var aim_position := 0

func _ready() -> void:
	assert(weapon)
	assert(damage_effect)

	Mortal.new(self, BIKER_HEALTH, sprite, _on_death)
	mgmt.use_bomb.connect(_on_death)
	mgmt.boss_died.connect(_on_death)
	mgmt.state.biker_count += 1

	await create_tween()\
		.tween_property(self, "position:z", rng.randf_range(BIKER_TARGET_Z_MIN, BIKER_TARGET_Z_MAX), BIKER_ENTRY_DURATION_S)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)\
		.finished


func _on_death() -> void:
	is_dead = true
	damage_effect.start()
	weapon.stop()
	sprite.hit_flash()
	mgmt.add_score(BIKER_SCORE)
	mgmt.state.biker_count -= 1

	# Disable collision
	collision_layer = 0
	collision_mask = 0

	# Make sprite shake
	if aim_position < 0:
		sprite.frame_end += 1
		sprite.frame_start += 1
	else:
		sprite.frame_start -= 1
		sprite.frame_end -= 1

	await mgmt.pausable_timer(1.0).timeout

	if randf() < BIKER_PICKUP_RATE:
		var pickup := PickupScene.instantiate()
		pickup.position = position
		pickup.position.y = 0.0
		add_sibling(pickup)

	queue_free()


func _anim_turn(direction: Dir) -> void:
	if is_dead:
		return

	match direction:
		Dir.LEFT:
			aim_position = max(-3, aim_position - 1)
		Dir.RIGHT:
			aim_position = min(3, aim_position + 1)

	var frame := posmod(sprite.frame, 2)
	if aim_position < 0:
		sprite.frame_start = 8 + 2 * aim_position
	else:
		sprite.frame_start = 18 - 2 * aim_position
	sprite.frame_end = sprite.frame_start + 1
	sprite.frame = sprite.frame_start + frame


func _on_timer_timeout() -> void:
	var player := mgmt.get_player()
	if player:
		if player.position.x < position.x:
			_anim_turn(Dir.LEFT)
		elif player.position.x > position.x:
			_anim_turn(Dir.RIGHT)
