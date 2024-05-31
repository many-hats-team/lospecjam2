class_name Enemy
extends CharacterBody3D


var health := 11


@onready var sprite: MySprite = %Sprite


func _ready() -> void:
	assert(sprite)
	Mortal.new(self, 11, sprite, _on_death)

	sprite.frame_start = posmod(randi(), 5) * 4
	sprite.frame_end = sprite.frame_start + 1

	mgmt.boss_died.connect(_on_death)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func setup(pos: Vector3, vel: Vector3) -> void:
	position = pos
	velocity = vel


func _on_death() -> void:
	queue_free()
	mgmt.add_score(100)
