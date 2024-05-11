extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")


func _ready() -> void:
	HitBox.new(self, _on_hit)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func setup(pos: Vector3, vel: Vector3) -> void:
	position = pos
	velocity = vel


func _on_hit() -> void:
	queue_free()
