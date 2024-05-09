extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

@export var move_range := 1.0
@export var speed := 0.001
@export var bullet_speed := 3.0


func _physics_process(_delta: float) -> void:
	position.x = move_range * sin(Time.get_ticks_msec() * speed)

