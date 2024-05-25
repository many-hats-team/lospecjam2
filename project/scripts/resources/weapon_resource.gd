class_name WeaponRes
extends Resource

enum Aiming {
	NONE,
	TARGET,
}

@export var mesh_kind: MeshGen.Kind = MeshGen.Kind.POINTY
@export var aim: Aiming = Aiming.NONE
@export var speed := 3.0
@export var spread := 0.0
@export var offset := 0.0
@export var count := 1
@export var reload_time := 0.5
