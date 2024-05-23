extends CharacterBody3D

const BulletScene := preload("res://scenes/bullet.tscn")

@export var move_range := 1.0
@export var speed := 0.001
@export var bullet_speed := 3.0

@onready var sprite: MySprite = %Sprite

@onready var trait_mortal := Mortal.new(self, 1000, sprite, _on_death)


func _ready() -> void:
	trait_mortal.health_changed.connect(_on_health_changed)


func _physics_process(_delta: float) -> void:
	position.x = move_range * sin(Time.get_ticks_msec() * speed)


func _on_health_changed(hp: int, maxhp: int) -> void:
	mgmt.boss_health_changed.emit(hp, maxhp)


func _on_death() -> void:
	queue_free()
	mgmt.add_score(10000)
