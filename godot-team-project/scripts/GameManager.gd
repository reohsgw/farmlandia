# Tatu Nyberg
extends Node

# Game state
var current_npc_index: int = 0
var minigames_completed: Array = [false, false, false]

# Timer
var total_time_played: float = 0.0

# Minigame scenes
var minigame_scenes: Array = [
	"res://scenes/minigames/Minigame1.tscn",
	"res://scenes/minigames/WhackAMole.tscn",
	"res://scenes/minigames/Minigame3.tscn"
]

func _process(delta: float) -> void:
	# Count time everywhere except MainMenu
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.name != "MainMenu":
		total_time_played += delta

func load_minigame(index: int) -> void:
	if index < minigame_scenes.size():
		get_tree().change_scene_to_file(minigame_scenes[index])

func complete_minigame(index: int) -> void:
	if index < minigames_completed.size():
		minigames_completed[index] = true
		current_npc_index += 1
		return_to_farm()

func return_to_farm() -> void:
	get_tree().change_scene_to_file("res://scenes/main/FarmHub.tscn")

func get_active_npc_index() -> int:
	return current_npc_index

func complete_game() -> void:
	print("=== GAME COMPLETED! ===")
	print("Total time: ", format_time(total_time_played))
	print("Minigames completed: 3/3")
	print("======================")

func format_time(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	return "%02d:%02d" % [minutes, seconds]

func reset_game() -> void:
	current_npc_index = 0
	minigames_completed = [false, false, false]
	total_time_played = 0.0
