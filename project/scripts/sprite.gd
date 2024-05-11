class_name MySprite
extends Sprite3D

const FLASH_DURATION_FRAMES := 2

var _is_flashing := false

func hit_flash() -> void:
	if not _is_flashing:
		_is_flashing = true
		var shader_material : ShaderMaterial = material_override
		shader_material.set_shader_parameter("flash", true)
		await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
		shader_material.set_shader_parameter("flash", false)
		await mgmt.wait_phys_frames(FLASH_DURATION_FRAMES)
		_is_flashing = false
