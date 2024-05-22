extends Node

signal paused
signal unpaused

const TYPICAL_ROAD_SPEED_MPS := 30.0

var road_speed := TYPICAL_ROAD_SPEED_MPS

var world: Node3D
var player: Player

func wait_phys_frames(n: int) -> void:
	for _i in range(n):
		await get_tree().physics_frame


func pause() -> void:
	get_tree().paused = true
	paused.emit()


func unpause() -> void:
	get_tree().paused = false
	unpaused.emit()
