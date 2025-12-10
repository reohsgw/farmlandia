#KURNIATI YASSIRLYA AMRINA
extends Node2D

var minigame_index: int = 1

@export var goal_score: int = 300
@export var time_limit: float = 60.0

var score: int = 0
var time_left: float = 0.0
var game_over: bool = false
var warned: bool = false
var clock_shaking: bool = false
var shake_time: float = 0.0
var clock_original_pos: Vector2

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
	clock_original_pos = clock_icon.position
	win_label.visible = false
	lose_label.visible = false
	goal_text.visible = false
	goal_bar.min_value = 0
	goal_bar.max_value = goal_score
	goal_bar.value = 0
	bar_text.text = "0%"
	_update_time_label()
	
	for child: Node in get_children():
		if child.has_signal("mole_hit"):
			child.mole_hit.connect(_on_mole_hit)

func _process(delta: float) -> void:
	if game_over:
		return
	time_left -= delta
	if time_left <= 3.0 and not warned:
		warned = true
		_start_final_warning()
	if time_left <= 0:
		time_left = 0
		_finish_game()
	_update_time_label()
	if clock_shaking:
		_shake_clock(delta)

func _on_mole_hit(points: int) -> void:
	if game_over:
		return
	score += points
	_update_goal_bar()

func _finish_game() -> void:
	game_over = true
	clock_shaking = false
	clock_icon.position = clock_original_pos
	_hide_gameplay_nodes()
	
	# Show score
	goal_text.text = "SCORE: %d / %d" % [score, goal_score]
	goal_text.visible = true
	
	# Create delay timer
	var timer = Timer.new()
	timer.wait_time = 2.5
	timer.one_shot = true
	add_child(timer)
	
	if score >= goal_score:
		# WIN
		win_label.visible = true
		lose_label.visible = false
		timer.timeout.connect(complete_minigame)
	else:
		# LOSE
		win_label.visible = false
		lose_label.visible = true
		timer.timeout.connect(return_to_farm_failed)
	
	timer.start()

func complete_minigame() -> void:
	GameManager.complete_minigame(minigame_index)

func return_to_farm_failed() -> void:
	GameManager.return_to_farm()

func _update_goal_bar() -> void:
	var clamped_value: int = min(score, goal_score)
	goal_bar.value = clamped_value
	var percent := float(score) / float(goal_score) * 100.0
	bar_text.text = "%.0f%%" % percent

func _update_time_label() -> void:
	time_label.text = "Time: %ds" % int(ceil(time_left))

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
	clock_icon.position = clock_original_pos + Vector2(offset_x, offset_y)

func _hide_gameplay_nodes() -> void:
	for child: Node in get_children():
		if child is CanvasLayer:
			continue
		if child.name.begins_with("TileMap"):
			continue
		if "visible" in child:
			child.visible = false
	time_label.visible = false
	clock_icon.visible = false
	goal_bar.visible = false
	bar_text.visible = false
