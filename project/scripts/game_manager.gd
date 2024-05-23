extends Node

signal paused
signal unpaused
signal player_lives_changed(lives: int)
signal score_changed(score: int)
signal boss_health_changed(hp: int, maxhp: int)

const TYPICAL_ROAD_SPEED_MPS := 30.0

var road_speed := TYPICAL_ROAD_SPEED_MPS

var world: Node3D
var player: Player

var player_lives := 8
var score := 0

func wait_phys_frames(n: int) -> void:
	for _i in range(n):
		await get_tree().physics_frame


func pause() -> void:
	get_tree().paused = true
	paused.emit()


func unpause() -> void:
	get_tree().paused = false
	unpaused.emit()


func add_score(x: int) -> void:
	score += x
	score_changed.emit(score)


func add_life(x: int) -> void:
	player_lives += x
	player_lives_changed.emit(player_lives)
