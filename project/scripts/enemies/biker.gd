extends CharacterBody3D

const CAR_HEALTH := 11
const CAR_SPEED := 4.0
const CAR_SCORE := 100


@onready var sprite: MySprite = %Sprite


func _ready() -> void:
	Mortal.new(self, CAR_HEALTH, sprite, _on_death)
	velocity = Vector3.BACK * CAR_SPEED

	sprite.frame_start = posmod(randi(), 5) * 4
	sprite.frame_end = sprite.frame_start + 1

	mgmt.boss_died.connect(_on_death)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_death() -> void:
	queue_free()
	mgmt.add_score(CAR_SCORE)
