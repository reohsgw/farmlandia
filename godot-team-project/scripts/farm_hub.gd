#Tatu Nyberg
extends Node2D

func _ready() -> void:
	# Simple refresh after scene loads
	call_deferred("refresh_npcs")

func refresh_npcs() -> void:
	var npcs = get_tree().get_nodes_in_group("npcs")
	for npc in npcs:
		if npc.has_method("update_npc_state"):
			npc.update_npc_state()
