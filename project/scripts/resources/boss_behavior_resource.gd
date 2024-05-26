class_name BossBehaviorRes
extends Resource

enum MoveKind {
	STILL,
	SINE,
}

@export var weapon: WeaponRes
@export var health := 200
@export var move_kind := MoveKind.STILL
@export var move_center := Vector3.ZERO
@export var move_range := 1.0
@export var move_speed := 0.001


