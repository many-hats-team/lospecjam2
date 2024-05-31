class_name DamageEffect
extends Node3D

enum Kind {
	SLASH,
	ELECTRIC,
	EXPLOSION,
}

@export var kind: Kind
@export var size := Vector2.ONE
@export var oneshot := false

@onready var rng := RandomNumberGenerator.new()
@onready var sprite := %Sprite as MySprite
@onready var sfx := %SFX as AudioStreamPlayer

func _ready() -> void:
	assert(sprite)
	assert(sfx)
	sprite.visible = false


func start() -> void:
	match kind:
		Kind.SLASH:
			sprite.frame_start = 0
		Kind.ELECTRIC:
			sprite.frame_start = 4
		Kind.EXPLOSION:
			sprite.frame_start = 8
		_:
			assert(false)
	sprite.frame_end = sprite.frame_start + 3
	sprite.frame = sprite.frame_start
	sprite.visible = true
	_run()


func stop() -> void:
	sprite.visible = false


func _run() -> void:
	var half_size := size * 0.5
	sprite.position = Vector3(
		rng.randf_range(-half_size.x, half_size.x),
		rng.randf_range(-half_size.y, half_size.y),
		0.1
	)
	sfx.play()


func _on_sprite_animation_cycle() -> void:
	if sprite.visible:
		if oneshot:
			sprite.visible = false
		else:
			_run()
