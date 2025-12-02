extends Node2D

@export var minigame_index: int = 0
@export var completion_time: float = 30.0
@export var instructions: String = "Complete the task!"

var is_completed: bool = false
var timer: float = 0.0


func _ready() -> void:
	print("Minigame %d started: %s" % [minigame_index, instructions])
	show_instructions()


func _process(delta: float) -> void:
	if not is_completed and completion_time > 0:
		timer += delta
		if timer >= completion_time:
			on_time_up()


func show_instructions() -> void:
	print("Instructions: %s" % instructions)


func on_time_up() -> void:
	print("Time's up!")
	complete_minigame()


func complete_minigame() -> void:
	if is_completed:
		return
	
	is_completed = true
	print("Minigame %d completed!" % minigame_index)
	GameManager.complete_minigame(minigame_index)
	await get_tree().create_timer(2.0).timeout
	return_to_hub()


func return_to_hub() -> void:
	GameManager.return_to_hub()


func start_minigame() -> void:
	pass


func check_win_condition() -> bool:
	return false
