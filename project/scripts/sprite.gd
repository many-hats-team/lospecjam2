@tool
class_name MySprite
extends Sprite3D

const FLASH_DURATION_FRAMES := 2

@export var frame_duration_s := 0.1:
	set(value):
		frame_duration_s = value
		if timer:
			timer.wait_time = value

@onready var timer := %Timer as Timer

var _is_flashing := false

func _ready() -> void:
	assert(timer)
	frame_duration_s = frame_duration_s
	timer.timeout.connect(_on_timer_timeout)

	_apply_texture()
	texture_changed.connect(_apply_texture)
	frame_changed.connect(_apply_texture)


func _apply_texture():
	if not texture:
		return

	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("texture_albedo", texture)
	shader_material.set_shader_parameter("uv1_offset", Vector3(
		posmod(frame, vframes) * (texture.get_width() / hframes),
		(frame / hframes) * (texture.get_height() / vframes),
		0.0
	))


func hit_flash() -> void:
	if not _is_flashing:
		_is_flashing = true
		var shader_material : ShaderMaterial = material_override
		shader_material.set_shader_parameter("flash", true)
		await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
		shader_material.set_shader_parameter("flash", false)
		await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
		_is_flashing = false


func _on_timer_timeout() -> void:
	frame = posmod(frame + 1, vframes * hframes)
