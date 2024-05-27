extends ParallaxBackground

@export var scroll_velocity := Vector2(-2.0, 0.0)

func _process(delta: float) -> void:
	scroll_offset += scroll_velocity * delta
