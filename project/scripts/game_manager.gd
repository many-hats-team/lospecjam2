extends Node

# Read/Write Signals: Below signals may be emitted by other scripts
signal quit_to_main_menu
signal boss_health_changed(hp: int)
signal boss_spawned
signal boss_died
signal boss_removed
signal game_over_win
signal game_over_lose
signal restart_requested

# Read-Only Signals: Below signals should only be emitted from this script
signal paused
signal unpaused
signal player_lives_changed(lives: int)
signal score_changed(score: int)

const BulletScene := preload("res://scenes/objects/bullet.tscn")

class GameState extends RefCounted:
	var player_lives := 8
	var score := 0
	var world_ref: WeakRef
	var player_ref: WeakRef

var state: GameState

@onready var _gen_meshes := MeshGen.new().get_meshes()


func _ready() -> void:
	reset_state()


func reset_state() -> void:
	state = GameState.new()


func set_world(world: Node3D) -> void:
	state.world_ref = weakref(world)
func get_world() -> Node3D:
	return state.world_ref.get_ref()

func set_player(player: Player) -> void:
	state.player_ref = weakref(player)
func get_player() -> Player:
	return state.player_ref.get_ref()


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
	state.score += x
	score_changed.emit(state.score)


func add_life(x: int) -> void:
	state.player_lives += x
	player_lives_changed.emit(state.player_lives)


func quit() -> void:
	get_tree().quit()
