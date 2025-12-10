#KURNIATI YASSIRLYA AMRINA

extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_hitting: bool = false

func _ready() -> void:
	sprite.animation = "idle"
	sprite.play()

func _process(delta: float) -> void:
	# Hammer following mouse
	global_position = get_global_mouse_position()

	# hitting pose by clicking left mouse
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not is_hitting:
		_do_hit()


func _do_hit() -> void:
	if is_hitting:
		return
	is_hitting = true

	# switch to hit pict
	sprite.animation = "hit"
	sprite.frame = 0
	sprite.play()
	await get_tree().create_timer(0.15).timeout

	# back to idle after hitting
	sprite.animation = "idle"
	sprite.play()
	is_hitting = false
