extends Node

# Read/Write Signals: Below signals may be emitted by other scripts
signal quit_to_main_menu
signal boss_health_changed(hp: int)
signal boss_spawned
signal boss_died
signal game_over_win
signal game_over_lose

# Read-Only Signals: Below signals should only be emitted from this script
signal paused
signal unpaused
signal player_lives_changed(lives: int)
signal score_changed(score: int)

const BulletScene := preload("res://scenes/objects/bullet.tscn")

var player_lives := 8
var score := 0

var _world_ref: WeakRef
func set_world(world: Node3D) -> void:
	_world_ref = weakref(world)
func get_world() -> Node3D:
	return _world_ref.get_ref()

var _player_ref: WeakRef
func set_player(player: Player) -> void:
	_player_ref = weakref(player)
func get_player() -> Player:
	return _player_ref.get_ref()


@onready var _gen_meshes := MeshGen.new().get_meshes()


func get_gen_mesh(kind: MeshGen.Kind) -> Mesh:
	var m := _gen_meshes[kind] as Mesh
	assert(m)
	return m


func wait_phys_frames(n: int) -> void:
	for _i in range(n):
		await get_tree().physics_frame


func pause() -> void:
	get_tree().paused = true
	paused.emit()


func unpause() -> void:
	get_tree().paused = false
	unpaused.emit()


func wait_until_unpause() -> void:
	while get_tree().paused:
		await get_tree().process_frame


func add_score(x: int) -> void:
	score += x
	score_changed.emit(score)


func add_life(x: int) -> void:
	player_lives += x
	player_lives_changed.emit(player_lives)


func quit() -> void:
	get_tree().quit()
