extends StaticBody2D

@export var npc_index: int = 0
@export var npc_name: String = "Farmer"
@export var inactive_dialogue: String = "Come back after helping the others first!"
@export var active_dialogue: String = "Can you help me with this task?"
@export var completed_dialogue: String = "Thanks for your help!"

var is_active: bool = false
var is_completed: bool = false

func _ready() -> void:
	add_to_group("npcs")
	update_npc_state()

func _process(_delta: float) -> void:
	# Show arrow indicator for active NPC
	if has_node("ActiveIndicator"):
		$ActiveIndicator.visible = is_active and not is_completed

func update_npc_state() -> void:
	var active_npc_index = GameManager.get_active_npc_index()
	
	if npc_index < active_npc_index:
		is_completed = true
		is_active = false
	elif npc_index == active_npc_index:
		is_active = true
		is_completed = false
	else:
		is_active = false
		is_completed = false
	
	update_visual()

func update_visual() -> void:
	if is_completed:
		modulate = Color(0.7, 0.7, 0.7)
	elif is_active:
		modulate = Color(1, 1, 1)
	else:
		modulate = Color(0.5, 0.5, 0.5)

func interact() -> void:
	update_npc_state()
	
	if is_completed:
		show_dialogue(completed_dialogue)
	elif is_active:
		show_dialogue(active_dialogue)
		await get_tree().create_timer(1.5).timeout
		start_minigame()
	else:
		show_dialogue(inactive_dialogue)

func show_dialogue(text: String) -> void:
	print("%s: %s" % [npc_name, text])
	
	if has_node("DialogueBubble"):
		var bubble = $DialogueBubble
		var label = $DialogueBubble/Panel/DialogueText
		var anim_player = $DialogueBubble/AnimationPlayer
		
		label.text = text
		bubble.visible = true
		anim_player.play("show")
		
		await get_tree().create_timer(3.0).timeout
		
		if anim_player:
			anim_player.play("hide")
			await anim_player.animation_finished
			if bubble:
				bubble.visible = false

func start_minigame() -> void:
	if npc_index < 3:
		GameManager.load_minigame(npc_index)
	else:
		GameManager.complete_game()
		show_dialogue("Congratulations! You've helped everyone on the farm!")
		await get_tree().create_timer(2.0).timeout
		get_tree().quit()
