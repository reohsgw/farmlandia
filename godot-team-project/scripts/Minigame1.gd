extends Node2D

var minigame_index: int = 0
var items_to_collect: int = 5
var items_collected: int = 0
var is_completed: bool = false



@onready var carrot_label = $CanvasLayer/VBoxContainer/HBoxContainer/CarrotLabel
@onready var whiteradish_label = $CanvasLayer/VBoxContainer/HBoxContainer2/WhiteRadishLabel
@onready var pumpkin_label = $CanvasLayer/VBoxContainer/HBoxContainer3/PumpkinLabel

func _ready() -> void:
	print("Minigame 1: Collect %d items!" % items_to_collect)
	create_temp_complete_button()
	$Player.carrot_collected.connect(_on_carrot_collected)
	$Player.whiteradish_collected.connect(_on_whiteradish_collected)
	$Player.pumpkin_collected.connect(_on_pumpkin_collected)

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

func _on_whiteradish_collected(new_value):
	whiteradish_label.text = str(new_value)

func _on_pumpkin_collected(new_value):
	pumpkin_label.text = str(new_value)
