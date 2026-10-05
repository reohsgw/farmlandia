extends Node2D

var minigame_index: int = 2
var is_completed: bool = false

@export var wolf_scene: PackedScene

@onready var sheep_label = $CanvasLayer/VBoxContainer/HBoxContainer/TextureRect/SheepLabel
@onready var wolf_label = $CanvasLayer/VBoxContainer/HBoxContainer2/TextureRect/WolfLabel
@onready var timer_label = $CanvasLayer/VBoxContainer/TimeLabel

@onready var win = $"CanvasLayer/YouWin"
@onready var lose = $"CanvasLayer/YouLose"

var spawn_area = Rect2(-200, -200, 1000, 800)
var forbidden_area = Rect2(400, 300, 200, 200)

var game_time = 0.0
var game_duration = 60.0
var game_active = true

var spawn_interval := 3.0
var spawn_timer := 0.0

var sheep_eaten_count = 0
var wolves_killed = 0

var total_sheep := 10
var total_wolves := 0


func _ready() -> void:
	print("Minigame 3: Survival!")
	create_temp_complete_button()

	# Hide result UI at start (important)
	if win: win.visible = false
	if lose: lose.visible = false

	spawn_wolf()
	update_labels()
	update_timer_label()


func _process(delta):
	# Stop everything if game is not active
	if not game_active:
		return

	# Wolf spawn timer
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_wolf()

	# Game time
	game_time += delta
	if game_time >= game_duration:
		game_won()
		return

	update_timer_label()


func spawn_wolf():
	if not game_active:
		return

	var pos = Vector2.ZERO
	while true:
		pos = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)
		if not forbidden_area.has_point(pos):
			break

	var wolf = wolf_scene.instantiate()
	wolf.position = pos
	add_child(wolf)

	total_wolves += 1
	update_labels()


func create_temp_complete_button() -> void:
	var label = Label.new()
	label.text = "Press SPACE to complete minigame (temporary)"
	label.position = Vector2(100, 50)
	add_child(label)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not is_completed:
		complete_minigame()


func complete_minigame() -> void:
	if is_completed:
		return
	is_completed = true

	print("Minigame 3 completed!")
	game_won()  # reuse the same win flow


func update_labels():
	sheep_label.text = "🐑 Sheep eated: %d" % sheep_eaten_count
	wolf_label.text = "🐺 Wolf killed: %d" % wolves_killed


func sheep_eaten():
	sheep_eaten_count += 1
	update_labels()

	# If you want lose condition, uncomment:
	# if sheep_eaten_count >= total_sheep:
	#     game_over("All sheep died!")


func wolf_shot():
	wolves_killed += 1
	update_labels()


func update_timer_label():
	var time_left = max(int(game_duration - game_time), 0)
	timer_label.text = "⏳ TIME LEFT: %d s" % time_left


# -----------------------
# WIN / LOSE + RETURN
# -----------------------
func game_won():
	if is_completed:
		return
	is_completed = true
	game_active = false

	if win:
		win.visible = true
		if win is Label:
			win.text = "🎉 You Win!"

	# wait a bit so player can see the message
	await get_tree().create_timer(2.5).timeout

	# mark complete then return to main screen
	GameManager.complete_minigame(minigame_index)
	GameManager.return_to_farm()  # change to return_to_hub() if your project uses that


func game_over(reason := ""):
	if is_completed:
		return
	is_completed = true
	game_active = false

	if lose:
		lose.visible = true
		if lose is Label:
			lose.text = "💀 You Lose!" if reason == "" else "💀 You Lose!\n%s" % reason

	await get_tree().create_timer(2.5).timeout

	# return without completion
	GameManager.return_to_farm()  # change to return_to_hub() if needed
