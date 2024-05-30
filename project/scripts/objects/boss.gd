class_name Boss
extends CharacterBody3D


const STAGE_FRAMES = 4

const origin := Vector3(0.0, 0.0, -6.0)


@export var stages: Array[BossBehaviorRes]


var stage := -1
var _t_ms := 0


@onready var sprite: MySprite = %Sprite
@onready var weapon: Weapon = %Weapon
@onready var trait_mortal := Mortal.new(self, 0, sprite, _on_death)



func _ready() -> void:
	assert(sprite)
	assert(weapon)

	# Wait for other nodes to connect to signals
	await get_tree().process_frame

	mgmt.boss_spawned.emit()
	next_stage()


func _physics_process(delta: float) -> void:
	# Lock Y coordinate
	position.y = origin.y

	if is_dead() or stage < 0:
		return

	_t_ms += int(delta * 1000.0)
	var res := stages[stage]

	var move_target: Vector3
	match res.move_kind:
		BossBehaviorRes.MoveKind.STILL:
			move_target = res.move_center
		BossBehaviorRes.MoveKind.SINE:
			move_target = res.move_center
			move_target.x = res.move_range * sin(_t_ms * res.move_speed)
		_:
			assert(false)

	position = util.damp(
		position,
		origin + move_target,
		1000.0 * min(res.move_speed, 0.001) * delta
	)


func is_dead() -> bool:
	return stage >= stages.size()


func next_stage() -> void:
	stage += 1

	mgmt.boss_health_changed.emit(stages.size() - stage)

	if is_dead():
		set_sprite_anim(4)
		mgmt.boss_died.emit()

		await get_tree().create_timer(3.0).timeout
		mgmt.boss_removed.emit()

		queue_free()
	else:
		var res := stages[stage]
		weapon.weapon = res.weapon
		trait_mortal.health = res.health

		match stage:
			0:
				set_sprite_anim(0)
			2:
				set_sprite_anim(1)
				await sprite.animation_cycle
				set_sprite_anim(2)
			3:
				set_sprite_anim(3)


func set_sprite_anim(row: int) -> void:
	sprite.frame_start = STAGE_FRAMES * row
	if row == 4:
		sprite.frame_end = sprite.frame_start
	else:
		sprite.frame_end = STAGE_FRAMES * (row + 1) - 1



func _on_death() -> void:
	mgmt.add_score(1000)
	next_stage()
