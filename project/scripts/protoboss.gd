extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

@export var range := 1.0
@export var speed := 0.001
@export var bullet_speed := 3.0


func _physics_process(delta: float) -> void:
	position.x = range * sin(Time.get_ticks_msec() * speed)


func _on_bullet_timer_timeout() -> void:
	var target := mgmt.player
	if target:
		var bullet_vel := (target.position - position).normalized() * bullet_speed
		spawn_bullet(bullet_vel)
		spawn_bullet(bullet_vel.rotated(Vector3.UP, 0.1))
		spawn_bullet(bullet_vel.rotated(Vector3.UP, -0.1))

func spawn_bullet(velocity: Vector3) -> void:
	var bullet := BulletScene.instantiate()
	get_parent().add_child(bullet)
	velocity.y = 0
	bullet.setup(position, velocity, true)
