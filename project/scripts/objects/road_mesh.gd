extends MeshInstance3D

@onready var shader := mesh.surface_get_material(0) as ShaderMaterial


func _ready() -> void:
	assert(shader)
	mgmt.paused.connect(func(): shader.set_shader_parameter(&"is_paused", true))
	mgmt.unpaused.connect(func(): shader.set_shader_parameter(&"is_paused", false))
