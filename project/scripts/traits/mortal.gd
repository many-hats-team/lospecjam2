class_name Mortal
extends Trait

static func trait_name() -> StringName:
	return "Mortal"

static func trait_get(obj: Object) -> Mortal:
	return Trait._trait_get(obj, trait_name()) as Mortal

var health: int
var sprite: MySprite
var _on_death: Callable

func _init(
	obj: Object,
	health: int,
	sprite: MySprite,
	on_death: Callable,
) -> void:
	assert(sprite)
	assert(on_death)
	super(obj)
	self.health = health
	self.sprite = sprite
	self._on_death = on_death
	HitBox.new(obj, _on_hit)

func _on_hit() -> void:
	if health <= 0:
		return

	mgmt.add_score(1)
	sprite.hit_flash()

	health -= 1
	if health <= 0:
		_on_death.call()
