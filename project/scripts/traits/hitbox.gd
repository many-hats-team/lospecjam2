class_name HitBox
extends Trait

static func trait_name() -> StringName:
	return &"HitBox"

static func trait_get(obj: Object) -> HitBox:
	return Trait._trait_get(obj, trait_name()) as HitBox

var _on_hit: Callable

func _init(obj: Object, on_hit: Callable) -> void:
	assert(on_hit)
	super(obj)
	_on_hit = on_hit

func hit() -> void:
	_on_hit.call()
