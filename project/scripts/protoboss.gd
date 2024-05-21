extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

@export var move_range := 1.0
@export var speed := 0.001
@export var bullet_speed := 3.0

var health := 1000

@onready var sprite: MySprite = %Sprite


func _ready() -> void:
	assert(sprite)
	HitBox.new(self, _on_hit)


func _physics_process(_delta: float) -> void:
	position.x = move_range * sin(Time.get_ticks_msec() * speed)


func _on_hit() -> void:
	health -= 1
	if health <= 0:
		queue_free()
		return

	sprite.hit_flash()
