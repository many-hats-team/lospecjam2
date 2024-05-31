extends Sprite2D


const BOMB_FLASH_S := 0.1


func _ready() -> void:
	visible = false
	mgmt.use_bomb.connect(flash)


func flash():
	visible = true
	await mgmt.pausable_timer(BOMB_FLASH_S).timeout
	visible = false
	await mgmt.pausable_timer(BOMB_FLASH_S).timeout
	visible = true
	await mgmt.pausable_timer(BOMB_FLASH_S).timeout
	visible = false
