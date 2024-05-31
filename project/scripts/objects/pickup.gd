extends Node3D

enum Kind {
	BOMB,
	LIFE,
}

const HOVER_AMPLITUDE := 0.2
const HOVER_SPEED := 2.0

const PICKUP_SPEED := 3.0
const PICKUP_DIST_SQ := 1.0

@onready var kind := randi_range(Kind.BOMB, Kind.LIFE) as Kind
@onready var sprite := %Sprite as MySprite
@onready var sfx := %SFX as AudioStreamPlayer

@onready var hover_t := 0.0
@onready var hover_origin_y := sprite.position.y

var is_picked_up := false

func _ready() -> void:
	assert(sprite)
	assert(sfx)

	match kind:
		Kind.BOMB:
			sprite.frame_start = 0
		Kind.LIFE:
			sprite.frame_start = 1
		_:
			assert(false)

	sprite.frame_end = sprite.frame_start


func _physics_process(delta: float) -> void:
	if is_picked_up:
		return

	position.z += PICKUP_SPEED * delta

	hover_t += delta
	sprite.position.y = hover_origin_y + HOVER_AMPLITUDE * sin(HOVER_SPEED * hover_t)

	var player := mgmt.get_player()
	if player:
		if player.position.distance_squared_to(position) <= PICKUP_DIST_SQ:
			is_picked_up = true

			match kind:
				Kind.BOMB:
					mgmt.pickup_bomb.emit()
				Kind.LIFE:
					mgmt.pickup_life.emit()
				_:
					assert(false)

			visible = false
			sfx.play()
			await sfx.finished
			queue_free()

