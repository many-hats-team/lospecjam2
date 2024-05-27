extends MeshInstance3D

@onready var shader := mesh.surface_get_material(0) as ShaderMaterial

var road_offset := 0.0

func _ready() -> void:
	assert(shader)
	mgmt.paused.connect(_on_pause)
	mgmt.unpaused.connect(_on_unpause)

func _on_pause() -> void:
	shader.set_shader_parameter(&"is_paused", true)

func _on_unpause() -> void:
	shader.set_shader_parameter(&"is_paused", false)
