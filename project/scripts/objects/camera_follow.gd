extends Camera3D

@export var enabled := true
@export var target_path: NodePath
@export var parallax_path: NodePath

@onready var target := get_node(target_path) as Node3D
@onready var bg := get_node(parallax_path) as ParallaxBackground

const SCROLL_SPEED := 0.2
const MAX_SCROLL := 40.0

var level_scroll := 0.0

func _ready() -> void:
	assert(target)
	assert(bg)


func _process(delta: float) -> void:
	level_scroll = min(MAX_SCROLL, level_scroll + SCROLL_SPEED * delta)

	if enabled:
		var weight := pow(0.3, delta * 10.0)
		global_position.x = lerpf(target.global_position.x, global_position.x, weight)

		bg.scroll_offset = Vector2(-global_position.x, -level_scroll)
