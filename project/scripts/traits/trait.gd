class_name Trait
extends RefCounted

## Template:
#class_name HitBox
#extends Trait
#
#static func trait_name() -> StringName:
#	return "HitBox"
#
#static func trait_get(obj: Object) -> HitBox:
#	return Trait._trait_get(obj, trait_name()) as HitBox

static func trait_name() -> StringName:
	assert(false, "not implemented")
	return ""

static func _trait_get(obj: Object, name: StringName) -> Trait:
	if obj == null:
		return null
	return obj.get_meta(name)

func trait_attach(obj: Object) -> void:
	obj.set_meta(trait_name(), self)
