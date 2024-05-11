extends Node

var world: Node3D
var player: Player

func wait_phys_frames(n: int) -> void:
	for _i in range(n):
		await get_tree().physics_frame
