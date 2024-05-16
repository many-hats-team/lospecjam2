extends Node

#const ROAD_FALLOFF_THRESHOLD_M = 5.0
#const ROAD_FALLOFF_RATE = 0.001

var world: Node3D
var player: Player

func wait_phys_frames(n: int) -> void:
	for _i in range(n):
		await get_tree().physics_frame


#func falloff(p: Vector3, height: float) -> Vector3:
	#if p.z < -ROAD_FALLOFF_THRESHOLD_M:
		#var x = -ROAD_FALLOFF_THRESHOLD_M - p.z
		#p.y = height - ROAD_FALLOFF_RATE * x * x;
	#else:
		#p.y = height
	#return p
