class_name util

static func multidup(sprite: Sprite2D, count: int, offset: float) -> Array[Sprite2D]:
	assert(sprite)
	assert(count >= 1)
	var out: Array[Sprite2D] = []
	for i in range(count - 1):
		var dup := sprite.duplicate()
		sprite.add_sibling(dup)
		out.append(dup)
		sprite.position.x += offset
	out.append(sprite)
	return out

static func damp(source, target, time: float, base: float = 1.0):
	return lerp(source, target, 1 - base * exp(-time))
