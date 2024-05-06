extends Camera3D

@export var enabled := true
@export var target_path: NodePath

@onready var target := get_node(target_path) as Node3D

func _ready() -> void:
	assert(target)


func _process(delta: float) -> void:
	if enabled:
		var weight := pow(0.3, delta * 10.0)
		global_position.x = lerpf(target.global_position.x, global_position.x, weight)
