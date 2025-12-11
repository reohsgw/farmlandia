
extends Node2D  # or CharacterBody2D if your NPC moves

@export var carrot_needed: int = 7
@export var pumpkin_needed: int = 5
@export var radish_needed: int = 3

# Drag your dialogue Label here in Inspector
@export var dialogue_label_path: NodePath

var dialogue_label: Label
var player

func _ready() -> void:
	# Get reference to dialogue label
	if dialogue_label_path != NodePath(""):
		dialogue_label = get_node(dialogue_label_path) as Label

	# Get the Player via group
	player = get_tree().get_first_node_in_group("player")

	# Show intro text at game start
	show_intro_message()


func show_intro_message() -> void:
	if dialogue_label:
		dialogue_label.text = "Collect 7 carrots, 5 pumpkins,\n3 radishes. Be careful of mushrooms!"


func interact() -> void:
	# Called from Player.interact_with_npc()
	if not dialogue_label or not player:
		return

	# Check if player has collected everything
	var has_all_carrot := player.carrots_collected >= carrot_needed
	var has_all_pumpkin := player.pumpkins_collected >= pumpkin_needed
	var has_all_radish := player.whiteradishes_collected >= radish_needed

	if has_all_carrot and has_all_pumpkin and has_all_radish:
		dialogue_label.text = "Thank you for your help!"
		# here you can also trigger win, e.g.:
		# GameManager.complete_minigame(…)
	else:
		# Optional: show what is still missing
		var missing: Array[String] = []

		if not has_all_carrot:
			missing.append("%d more carrot(s)" % (carrot_needed - player.carrots_collected))
		if not has_all_pumpkin:
			missing.append("%d more pumpkin(s)" % (pumpkin_needed - player.pumpkins_collected))
		if not has_all_radish:
			missing.append("%d more radish(es)" % (radish_needed - player.whiteradishes_collected))

		dialogue_label.text = "You still need:\n" + ", ".join(missing)
