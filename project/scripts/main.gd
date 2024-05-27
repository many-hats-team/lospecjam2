extends Node

const MainMenuScene := preload("res://scenes/main_menu.tscn")
const GameScene := preload("res://scenes/game.tscn")

func _ready() -> void:
	mgmt.quit_to_main_menu.connect(start_main_menu)
	start_main_menu()


func start_main_menu() -> void:
	var mm := change_scene(MainMenuScene) as MainMenu
	mm.game_started.connect(start_game)


func start_game() -> void:
	change_scene(GameScene)


func change_scene(scene: PackedScene) -> Node:
	var node := util.try_get_child(self, 0)
	if node:
		remove_child(node)
		node.queue_free()

	node = scene.instantiate()
	add_child(node)
	return node
