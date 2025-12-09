extends Node2D

func _ready() -> void:
	print("FarmHub loading...")
	print("GameManager state: ", GameManager.minigames_completed)
	print("Current NPC index: ", GameManager.current_npc_index)
	
	# Refresh NPCs multiple times to ensure it sticks
	call_deferred("refresh_npcs")
	await get_tree().create_timer(0.1).timeout
	refresh_npcs()
	await get_tree().create_timer(0.1).timeout
	refresh_npcs()

func refresh_npcs() -> void:
	var npcs = get_tree().get_nodes_in_group("npcs")
	print("Refreshing ", npcs.size(), " NPCs...")
	for npc in npcs:
		if npc.has_method("update_npc_state"):
			print("  Updating NPC ", npc.npc_index)
			npc.update_npc_state()
	print("NPCs refreshed!")
