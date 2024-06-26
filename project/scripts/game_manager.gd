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
signal pause_menu_opened
signal pause_menu_closed
signal pickup_life
signal pickup_bomb
signal use_bomb

# Read-Only Signals: Below signals should only be emitted from this script
signal paused
signal unpaused
signal player_lives_changed(lives: int)
signal score_changed(score: int)

const PLAYER_MAX_LIVES := 8

const BulletScene := preload("res://scenes/objects/bullet.tscn")

class GameState extends RefCounted:
	var player_lives := PLAYER_MAX_LIVES / 2
	var score := 0
	var world_ref: WeakRef = weakref(null)
	var player_ref: WeakRef = weakref(null)
	var biker_count := 0
	var has_bomb := false

var state: GameState

@onready var _gen_meshes := MeshGen.new().get_meshes()


func _ready() -> void:
	reset_state()

	pickup_life.connect(func(): add_life(1))
	pickup_bomb.connect(func():
		state.has_bomb = true
	)
	use_bomb.connect(func():
		state.has_bomb = false
	)


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
	if state.player_lives > PLAYER_MAX_LIVES:
		state.player_lives = PLAYER_MAX_LIVES
		add_score(200)
	player_lives_changed.emit(state.player_lives)


func quit() -> void:
	get_tree().quit()


func pausable_timer(time_sec: float) -> SceneTreeTimer:
	return get_tree().create_timer(time_sec, false)


func unpausable_timer(time_sec: float) -> SceneTreeTimer:
	return get_tree().create_timer(time_sec)
