extends CharacterBody3D

@export var stages: Array[BossBehaviorRes]


var stage := -1
var _t_ms := 0


@onready var sprite: MySprite = %Sprite
@onready var weapon: Weapon = %Weapon
@onready var trait_mortal := Mortal.new(self, 0, sprite, _on_death)
@onready var origin := position


func _ready() -> void:
	assert(sprite)
	assert(weapon)

	# Wait for other nodes to connect to signals
	await get_tree().process_frame

	next_stage()


func _physics_process(delta: float) -> void:
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
		1000.0 * res.move_speed * delta
	)


func is_dead() -> bool:
	return stage >= stages.size()


func next_stage() -> void:
	stage += 1

	mgmt.boss_health_changed.emit(stages.size() - stage)

	if is_dead():
		queue_free()
	else:
		var res := stages[stage]
		weapon.weapon = res.weapon
		trait_mortal.health = res.health


func _on_death() -> void:
	mgmt.add_score(1000)
	next_stage()
