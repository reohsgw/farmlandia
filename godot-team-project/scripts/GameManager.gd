extends Node

# Singleton that tracks game progress and manages scene transitions

# Game progress tracking
var minigames_completed: Array = [false, false, false]
var current_npc_index: int = 0
var game_won: bool = false

var total_time_played: float = 0.0

# Scene paths
const FARM_HUB = "res://scenes/main/FarmHub.tscn"
const MINIGAME_1 = "res://scenes/minigames/Minigame1.tscn"
const MINIGAME_2 = "res://scenes/minigames/Minigame2.tscn"
const MINIGAME_3 = "res://scenes/minigames/Minigame3.tscn"

signal minigame_completed(index: int)
signal game_complete


func _ready() -> void:
	print("GameManager initialized")


func is_minigame_completed(index: int) -> bool:
	if index < 0 or index >= minigames_completed.size():
		return false
	return minigames_completed[index]


func complete_minigame(index: int) -> void:
	if index >= 0 and index < minigames_completed.size():
		minigames_completed[index] = true
		current_npc_index += 1
		minigame_completed.emit(index)
		print("Minigame %d completed!" % index)


func get_active_npc_index() -> int:
	return current_npc_index


func all_minigames_completed() -> bool:
	return minigames_completed.all(func(completed): return completed)


func complete_game() -> void:
	game_won = true
	game_complete.emit()
	print("Game completed! You won!")


func load_scene(scene_path: String) -> void:
	get_tree().call_deferred("change_scene_to_file", scene_path)


func load_minigame(index: int) -> void:
	match index:
		0:
			load_scene(MINIGAME_1)
		1:
			load_scene(MINIGAME_2)
		2:
			load_scene(MINIGAME_3)
		_:
			print("Invalid minigame index: %d" % index)


func return_to_hub() -> void:
	load_scene(FARM_HUB)


func reset_game() -> void:
	minigames_completed = [false, false, false]
	current_npc_index = 0
	game_won = false
	print("Game reset")
	
func _process(delta: float) -> void:
	# Count time in game, not in menu
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.name != "MainMenu":
		total_time_played += delta
