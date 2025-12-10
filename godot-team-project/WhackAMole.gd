#KURNIATI YASSIRLYA AMRINA

extends Node2D

@export var goal_score: int = 300        # Target score to win
@export var time_limit: float = 60.0     # Game length in seconds

# game state
var score: int = 0
var time_left: float = 0.0
var game_over: bool = false

# Countdown warning state
var warned: bool = false
var clock_shaking: bool = false
var shake_time: float = 0.0

# shaking in original position
var clock_original_pos: Vector2

# UI REFERENCES
@onready var time_label: Label          = $UIMole/TimeLabel
@onready var clock_icon: TextureRect    = $UIMole/ClockIcon
@onready var win_label: Label           = $UIMole/WinLabel
@onready var lose_label: Label          = $UIMole/LoseLabel
@onready var goal_bar: ProgressBar      = $UIMole/GoalBar
@onready var bar_text: Label            = $UIMole/GoalBar/BarText
@onready var goal_text: Label           = $UIMole/GoalText
@onready var warning_sfx: AudioStreamPlayer2D = $UIMole/WarningSfx
@onready var bgm: AudioStreamPlayer     = $MoleBGM

func _ready() -> void:
	time_left = time_limit

	# Save original clock position for shaking animation
	clock_original_pos = clock_icon.position

	# Initial UI setup
	win_label.visible = false
	lose_label.visible = false
	goal_text.visible = false

	goal_bar.min_value = 0
	goal_bar.max_value = goal_score
	goal_bar.value = 0
	bar_text.text = "0%"

	_update_time_label()

	# Connect mole hit signals
	for child: Node in get_children():
		if child.has_signal("mole_hit"):
			child.mole_hit.connect(_on_mole_hit)

# timer
func _process(delta: float) -> void:
	if game_over:
		return

	time_left -= delta

	# Trigger final 3-second warning once
	if time_left <= 3.0 and not warned:
		warned = true
		_start_final_warning()

	# Time’s up
	if time_left <= 0:
		time_left = 0
		_finish_game()

	_update_time_label()

	# Shake clock
	if clock_shaking:
		_shake_clock(delta)

# score update
func _on_mole_hit(points: int) -> void:
	if game_over:
		return

	score += points
	_update_goal_bar()


# game end
func _finish_game() -> void:
	game_over = true

	# Stop shaking and reset clock icon position
	clock_shaking = false
	clock_icon.position = clock_original_pos

	# Hide gameplay elements
	_hide_gameplay_nodes()

	# Show win / lose label
	if score >= goal_score:
		win_label.visible = true
		lose_label.visible = false
	else:
		win_label.visible = false
		lose_label.visible = true

	# Show final score 
	goal_text.text = "SCORE: %d / %d" % [goal_score, score]
	goal_text.visible = true

func _update_goal_bar() -> void:
	var clamped_value: int = min(score, goal_score)
	goal_bar.value = clamped_value

	# Percent (can exceed 100%)
	var percent := float(score) / float(goal_score) * 100.0
	bar_text.text = "%.0f%%" % percent


func _update_time_label() -> void:
	time_label.text = "Time: %ds" % int(ceil(time_left))

#3 seconds warning
func _start_final_warning() -> void:
	warning_sfx.play()
	clock_shaking = true

func _shake_clock(delta: float) -> void:
	shake_time += delta

	if time_left <= 0:
		clock_shaking = false
		clock_icon.position = clock_original_pos
		return

	var strength := 3.0
	var offset_x := sin(shake_time * 20.0) * strength
	var offset_y := cos(shake_time * 25.0) * strength

	# Shake around the original position
	clock_icon.position = clock_original_pos + Vector2(offset_x, offset_y)

#hod gameplay after the game is over
func _hide_gameplay_nodes() -> void:
	# Hide all non-background, non-UI nodes
	for child: Node in get_children():
		if child is CanvasLayer:
			continue
		if child.name.begins_with("TileMap"):  # Keep background
			continue
		if "visible" in child:
			child.visible = false

	# Hide gameplay UI items
	time_label.visible = false
	clock_icon.visible = false
	goal_bar.visible = false
	bar_text.visible = false
