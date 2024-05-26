extends Node3D

const BulletScene := preload("res://scenes/bullet.tscn")


@export var weapon: WeaponRes:
	set(w):
		weapon = w
		if w and reload_timer and burst_timer:
			w.validate()
			reload_timer.wait_time = weapon.reload_time
			if weapon.burst_count > 1:
				burst_timer.wait_time = weapon.burst_time / weapon.burst_count
			if auto_fire:
				start()

@export var is_enemy := false
@export var auto_fire := false

@onready var reload_timer := %ReloadTimer as Timer
@onready var burst_timer := %BurstTimer as Timer


func _ready() -> void:
	assert(reload_timer)
	assert(burst_timer)
	weapon = weapon



func _on_timer_timeout() -> void:
	shoot()


func start() -> void:
	reload_timer.start()


func stop() -> void:
	reload_timer.stop()


func shoot() -> void:
	if not weapon:
		stop()
		return

	if weapon.burst_count > 1:
		burst_timer.start()
		for i in range(weapon.burst_count):
			_shoot_round()
			await burst_timer.timeout
		burst_timer.stop()
	else:
		_shoot_round()

	if not auto_fire:
		stop()


func _shoot_round() -> void:
	if not weapon:
		return

	var mesh := mgmt.get_gen_mesh(weapon.mesh_kind)
	var gpos := global_position

	var direction: Vector3
	match [weapon.aim, is_enemy]:
		[WeaponRes.Aiming.NONE, false]:
			direction = Vector3.FORWARD
		[WeaponRes.Aiming.NONE, true]:
			direction = Vector3.BACK
		[WeaponRes.Aiming.TARGET, false]:
			assert(false, "todo")
			return
		[WeaponRes.Aiming.TARGET, true]:
			var player := mgmt.get_player()
			if player:
				direction = (player.global_position - gpos).normalized()
		_:
			assert(false)
			return

	var velocity := direction * weapon.speed
	var count := weapon.count

	if count <= 1:
		_spawn_bullet(gpos, velocity, is_enemy, mesh)
	else:
		var offset := weapon.offset
		var a := 0.5 * PI * weapon.spread
		var r := 2.0 / (count - 1)
		for i in range(count):
			_spawn_bullet(
				gpos + Vector3((2.0 * offset / (count - 1) * i - offset), 0, 0),
				velocity.rotated(
					Vector3.UP,
					a * (r * i - 1.0)
				),
				is_enemy,
				mesh
			)


func _spawn_bullet(
	gpos: Vector3,
	velocity: Vector3,
	is_enemy_bullet: bool,
	mesh: Mesh
) -> void:
	var world := mgmt.get_world()
	if world:
		var bullet := BulletScene.instantiate()
		world.add_child(bullet)
		velocity.y = 0
		bullet.setup(gpos, velocity, is_enemy_bullet, mesh)
