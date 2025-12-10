#HASEGAWA REO 

extends Node2D

var minigame_index: int = 0
var items_to_collect: int = 5
var items_collected: int = 0
var is_completed: bool = false



@onready var carrot_label = $CanvasLayer/VBoxContainer/HBoxContainer/CarrotLabel
@onready var whiteradish_label = $CanvasLayer/VBoxContainer/HBoxContainer2/WhiteRadishLabel
@onready var pumpkin_label = $CanvasLayer/VBoxContainer/HBoxContainer3/PumpkinLabel

const MAX_TIME: float = 60.0  

@onready var game_timer: Timer = $GameTimer
@onready var time_bar: TextureProgressBar = $CanvasLayer3/HBoxContainer/TimerBar
@onready var game_over_label: Label = $CanvasLayer3/GameOverLabel
@onready var collect_sfx: AudioStreamPlayer2D = $CollectSFX
@onready var gameover_sfx: AudioStreamPlayer2D = $GameOverSFX
@onready var win_sfx: AudioStreamPlayer2D = $WinSFX
@onready var bgm: AudioStreamPlayer2D = $bgm

func _ready() -> void:
	print("Minigame 1: Collect %d items!" % items_to_collect)
	create_temp_complete_button()
	$Player.carrot_collected.connect(_on_carrot_collected)
	$Player.whiteradish_collected.connect(_on_whiteradish_collected)
	$Player.pumpkin_collected.connect(_on_pumpkin_collected)
	
	$Player.player_won.connect(_on_player_won)
	$Player.player_missing_items.connect(_on_player_missing_items)
	
	game_timer.wait_time = MAX_TIME
	game_timer.start()

	game_timer.timeout.connect(_on_GameTimer_timeout)

	time_bar.max_value = MAX_TIME
	time_bar.value = MAX_TIME

func create_temp_complete_button() -> void:
	# Temporary auto-complete for testing
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
	print("Minigame 1 completed!")
	GameManager.complete_minigame(minigame_index)
	await get_tree().create_timer(1.0).timeout
	GameManager.return_to_hub()

func _on_carrot_collected(new_value):
	carrot_label.text = str(new_value)
	collect_sfx.play()

func _on_whiteradish_collected(new_value):
	whiteradish_label.text = str(new_value)
	collect_sfx.play()

func _on_pumpkin_collected(new_value):
	pumpkin_label.text = str(new_value)
	collect_sfx.play()

func _on_GameTimer_timeout() -> void:
	if is_completed:
		return 
	show_game_over()
	
func show_game_over() -> void:
	game_over_label.visible = true
	game_over_label.text = "MISSION FAILED"
	gameover_sfx.play()
	bgm.stop()     
	get_tree().paused = true   
	
func _process(delta: float) -> void:
	time_bar.value = game_timer.time_left

func _on_player_won():
	show_win_message()

func _on_player_missing_items():
	show_need_items_message()

func show_win_message() -> void:
	bgm.stop()     
	game_over_label.add_theme_color_override("font_color", Color(0, 1, 0))
	game_over_label.visible = true
	game_over_label.text = "MISSION COMPLETED!"
	win_sfx.play()
	get_tree().paused = true
	
func show_need_items_message() -> void:
	game_over_label.visible = true
	game_over_label.text = "NOT ENOUGH ITEMS!"
	await get_tree().create_timer(2.0).timeout
	game_over_label.visible = false
