extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

@export var move_range := 1.0
@export var speed := 0.001
@export var bullet_speed := 3.0

@onready var sprite: MySprite = %Sprite


func _ready() -> void:
	assert(sprite)
	Mortal.new(self, 1000, sprite, _on_death)


func _physics_process(_delta: float) -> void:
	position.x = move_range * sin(Time.get_ticks_msec() * speed)


func _on_death() -> void:
	queue_free()
