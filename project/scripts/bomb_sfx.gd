extends AudioStreamPlayer


func _ready() -> void:
	mgmt.use_bomb.connect(play)
