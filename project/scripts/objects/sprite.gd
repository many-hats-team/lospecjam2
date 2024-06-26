@tool
class_name MySprite
extends Sprite3D

signal animation_cycle

const FLASH_DURATION_FRAMES := 2

@export var frame_duration_s := 0.1:
	set(value):
		frame_duration_s = value
		if timer:
			timer.wait_time = value

@export var frame_start := 0:
	set(value):
		frame_start = value
		frame = max(frame, value)
@export var frame_end := 1:
	set(value):
		frame_end = value
		frame = min(frame, value)

@onready var timer := %Timer as Timer
@onready var flash_sfx := %FlashSfx as AudioStreamPlayer

var _is_flashing := false
var _is_blinking := false

func _ready() -> void:
	assert(timer)
	assert(flash_sfx)

	frame_duration_s = frame_duration_s
	timer.timeout.connect(next_frame)

	frame = frame_start

	_apply_texture()
	texture_changed.connect(_apply_texture)
	frame_changed.connect(_apply_texture)


func _apply_texture():
	if not texture:
		return

	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter(&"texture_albedo", texture)
	shader_material.set_shader_parameter(&"uv1_offset", Vector3(
		posmod(frame, vframes) * (texture.get_width() / hframes),
		(frame / hframes) * (texture.get_height() / vframes),
		0.0
	))


func blink(duration: float) -> void:
	if not _is_blinking:
		_is_blinking = true
		var timer := mgmt.pausable_timer(duration)
		while timer.time_left > 0.0:
			visible = false
			await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
			visible = true
			await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
		_is_blinking = false


func set_flash(enabled: bool) -> void:
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter(&"flash", enabled)


func hit_flash() -> void:
	if not _is_flashing:
		_is_flashing = true
		flash_sfx.play()
		set_flash(true)
		await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
		set_flash(false)
		await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
		_is_flashing = false


func next_frame() -> void:
	var n = frame + 1
	if n > frame_end:
		n = frame_start
	frame = n
	if frame == frame_start:
		animation_cycle.emit()
