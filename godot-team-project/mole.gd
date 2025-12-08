extends Area2D

signal mole_hit

# How long the mole stays visible when it pops up
@export var up_time: float = 0.8

# Frames from your spritesheet (set these in the Inspector)
@export var hole_frame: int = 0   # just the hole
@export var up_frame: int = 1     # mole up
@export var hit_frame: int = 1    # you can change to a "hit" frame later

enum State { HOLE, UP, HIT }

var state: State = State.HOLE
var can_be_hit: bool = false


func _ready() -> void:
	# Make sure this Area2D can receive mouse clicks
	input_pickable = true
	state = State.HOLE
	_update_visual()


func _update_visual() -> void:
	var sprite: Sprite2D = $Sprite2D
	match state:
		State.HOLE:
			sprite.frame = hole_frame
		State.UP:
			sprite.frame = up_frame
		State.HIT:
			sprite.frame = hit_frame


func pop_up() -> void:
	# Called by your game controller to make this mole appear
	if state != State.HOLE:
		return

	state = State.UP
	can_be_hit = true
	_update_visual()

	# Stay up for a while, then go down if not hit
	await get_tree().create_timer(up_time).timeout
	if state == State.UP:
		go_down()


func go_down() -> void:
	state = State.HOLE
	can_be_hit = false
	_update_visual()


func _input_event(viewport, event, shape_idx) -> void:
	# Called automatically when the mouse interacts with this Area2D
	if not can_be_hit:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed \
	and state == State.UP:
		state = State.HIT
		can_be_hit = false
		_update_visual()
		emit_signal("mole_hit")
		go_down()
