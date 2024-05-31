extends CharacterBody3D

const CAR_HEALTH := 11
const CAR_SPEED := 4.0


@onready var sprite = %Sprite as MySprite
@onready var damage_effect = %DamageEffect as DamageEffect


var is_dead := false


func _ready() -> void:
	assert(damage_effect)
	Mortal.new(self, CAR_HEALTH, sprite, _on_death)
	velocity = Vector3.BACK * CAR_SPEED

	sprite.frame_start = posmod(randi(), 5) * 4
	sprite.frame_end = sprite.frame_start + 1

	mgmt.boss_died.connect(_on_death)


func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity += Vector3.BACK * 0.1
	move_and_slide()


func _on_death() -> void:
	is_dead = true
	damage_effect.start()
	sprite.frame_start = 5 * 4
	sprite.frame_end = sprite.frame_start + 1
	sprite.frame = sprite.frame_start
