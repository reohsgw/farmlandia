extends Node2D

var minigame_index: int = 0
var items_to_collect: int = 5
var items_collected: int = 0
var is_completed: bool = false


func _ready() -> void:
	print("Minigame 1: Collect %d items!" % items_to_collect)
	create_temp_complete_button()


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
