class_name HitBox
extends Trait

static func trait_name() -> StringName:
	return "HitBox"

static func trait_get(obj: Object) -> HitBox:
	return Trait._trait_get(obj, trait_name()) as HitBox

var _hit: Callable

func _init(hitFn: Callable) -> void:
	_hit = hitFn

func hit() -> void:
	_hit.call()
