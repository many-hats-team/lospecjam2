extends AudioStreamPlayer


@onready var default_volume_db := volume_db

var is_game_over_win := false

func _ready() -> void:
	mgmt.paused.connect(_on_pause)
	mgmt.unpaused.connect(_on_unpause)
	mgmt.pause_menu_opened.connect(_on_pause_menu_opened)
	mgmt.pause_menu_closed.connect(_on_pause_menu_closed)
	mgmt.game_over_win.connect(_on_game_over_win)

func _on_game_over_win() -> void:
	is_game_over_win = true

func _on_pause_menu_opened() -> void:
	if not is_game_over_win:
		stream_paused = true

func _on_pause_menu_closed() -> void:
	stream_paused = false

func _on_pause() -> void:
	if not is_game_over_win:
		volume_db = -20.0

func _on_unpause() -> void:
	volume_db = default_volume_db
