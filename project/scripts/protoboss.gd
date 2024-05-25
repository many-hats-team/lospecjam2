extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

@export var move_range := 1.0
@export var speed := 0.001
@export var bullet_speed := 3.0

@onready var sprite: MySprite = %Sprite

@onready var trait_mortal := Mortal.new(self, 1000, sprite, _on_death)


var _t_ms := 0


func _ready() -> void:
	trait_mortal.health_changed.connect(_on_health_changed)


func _physics_process(delta: float) -> void:
	_t_ms += int(delta * 1000.0)
	position.x = move_range * sin(_t_ms * speed)


func _on_health_changed(hp: int, maxhp: int) -> void:
	mgmt.boss_health_changed.emit(hp, maxhp)


func _on_death() -> void:
	queue_free()
	mgmt.add_score(10000)
