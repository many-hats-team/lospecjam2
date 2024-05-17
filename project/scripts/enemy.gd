extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")


var health := 11


@onready var sprite: MySprite = %Sprite


func _ready() -> void:
	assert(sprite)
	HitBox.new(self, _on_hit)

	sprite.frame_start = posmod(randi(), 5) * 4
	sprite.frame_end = sprite.frame_start + 1


func _physics_process(_delta: float) -> void:
	move_and_slide()


func setup(pos: Vector3, vel: Vector3) -> void:
	position = pos
	velocity = vel


func _on_hit() -> void:
	health -= 1
	if health <= 0:
		queue_free()
		return

	sprite.hit_flash()
