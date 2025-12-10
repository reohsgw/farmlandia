#KURNIATI YASSIRLYA AMRINA

extends Area2D

signal mole_hit(points: int)

@export var min_idle_time: float = 0.5   # min random wait (hole only)
@export var max_idle_time: float = 2.0   # max random wait
@export var up_time: float = 1.0         # stay fully up for up_time seconds

@export var bomb_chance: float = 0.3     # chance this appearance is a bomb
@export var normal_points: int = 5       # score for normal mole
@export var bomb_points: int = -3        # score for bomb mole

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var is_up: bool = false
var was_hit: bool = false
var is_bomb: bool = false               

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_sfx: AudioStreamPlayer2D = $HitSfx
@onready var bomb_sfx: AudioStreamPlayer2D = $BombSfx


func _ready() -> void:
	rng.randomize()
	show_hole()
	_cycle()   # start the loop


func _cycle() -> void:
	while true:
		was_hit = false

		# Decide type for this round: normal or bomb
		is_bomb = rng.randf() < bomb_chance

		# random wait with only the hole visible
		var idle_time: float = rng.randf_range(min_idle_time, max_idle_time)
		await get_tree().create_timer(idle_time).timeout

		# pop up animation
		await pop_once()

		# stay up until time runs out or gets hit
		await stay_up_or_hit()

		# if hit and it's a NORMAL mole, play hit animation
		#    (bomb mole skips hit animation)
		if was_hit:
			await play_hit_animation()

		# back to hole and loop again
		show_hole()


func show_hole() -> void:
	is_up = false
	was_hit = false
	sprite.animation = "pop"
	sprite.frame = 0      # frame 0 = hole only


func pop_once() -> void:
	is_up = true
	was_hit = false

	if is_bomb and sprite.sprite_frames.has_animation("bomb"):
		# Bomb animation
		sprite.animation = "bomb"
		var frames_bomb: int = sprite.sprite_frames.get_frame_count("bomb")
		var step_time_bomb: float = 0.1

		for i in range(frames_bomb):
			if was_hit:
				return
			sprite.frame = i
			await get_tree().create_timer(step_time_bomb).timeout
	else:
		# Normal mole pop 
		sprite.animation = "pop"
		var frames_normal: int = 6        
		var step_time_normal: float = 0.1

		for j in range(frames_normal):
			if was_hit:
				return
			sprite.frame = j
			await get_tree().create_timer(step_time_normal).timeout

func stay_up_or_hit() -> void:
	var elapsed: float = 0.0
	while elapsed < up_time and not was_hit:
		await get_tree().process_frame
		var delta: float = get_process_delta_time()
		elapsed += delta


func play_hit_animation() -> void:
	is_up = false

	# Bomb mole: NO hit animation, just disappear
	if is_bomb:
		return

	# Normal mole
	sprite.animation = "hit"
	var frames_hit: int = 3
	var step_time_hit: float = 0.08

	for i in range(frames_hit):
		sprite.frame = i
		await get_tree().create_timer(step_time_hit).timeout


# called from click & hammer
func hit() -> void:
	if not is_up or was_hit:
		return

	was_hit = true

	# SFX: bomb or normal
	var sfx: AudioStreamPlayer2D = bomb_sfx if is_bomb else hit_sfx
	if sfx:
		sfx.play()

	# Normal mole: +5, Bomb mole: -3
	var points: int = bomb_points if is_bomb else normal_points
	mole_hit.emit(points)


func _input_event(viewport, event, shape_idx) -> void:
	if not is_up:
		return

	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		hit()
