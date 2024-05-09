extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")


func _physics_process(delta: float) -> void:
	move_and_slide()


func setup(pos: Vector3, vel: Vector3) -> void:
	position = pos
	velocity = vel
