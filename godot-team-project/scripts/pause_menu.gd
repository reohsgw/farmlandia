#Tatu Nyberg
extends CanvasLayer

# References
var pause_panel: Panel
var settings_panel: Panel
var minigame1_check: CheckBox
var minigame2_check: CheckBox
var minigame3_check: CheckBox

func _ready() -> void:
	visible = false
	
	pause_panel = $PausePanel if has_node("PausePanel") else null
	settings_panel = $SettingsPanel if has_node("SettingsPanel") else null
	minigame1_check = $SettingsPanel/VBoxContainer/Minigame1Check if has_node("SettingsPanel/VBoxContainer/Minigame1Check") else null
	minigame2_check = $SettingsPanel/VBoxContainer/Minigame2Check if has_node("SettingsPanel/VBoxContainer/Minigame2Check") else null
	minigame3_check = $SettingsPanel/VBoxContainer/Minigame3Check if has_node("SettingsPanel/VBoxContainer/Minigame3Check") else null
	
	connect_buttons()
	
	if settings_panel:
		settings_panel.visible = false

func connect_buttons() -> void:
	if has_node("PausePanel/VBoxContainer/ResumeButton"):
		$PausePanel/VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	
	if has_node("PausePanel/VBoxContainer/SettingsButton"):
		$PausePanel/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	
	if has_node("PausePanel/VBoxContainer/RestartButton"):
		$PausePanel/VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	
	if has_node("PausePanel/VBoxContainer/MainMenuButton"):
		$PausePanel/VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	
	if has_node("PausePanel/VBoxContainer/ExitButton"):
		$PausePanel/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	
	if has_node("SettingsPanel/VBoxContainer/BackButton"):
		$SettingsPanel/VBoxContainer/BackButton.pressed.connect(_on_settings_back)
	
	if has_node("SettingsPanel/VBoxContainer/ResetProgressButton"):
		$SettingsPanel/VBoxContainer/ResetProgressButton.pressed.connect(_on_reset_progress)
	
	if minigame1_check:
		minigame1_check.toggled.connect(_on_minigame1_toggled)
	if minigame2_check:
		minigame2_check.toggled.connect(_on_minigame2_toggled)
	if minigame3_check:
		minigame3_check.toggled.connect(_on_minigame3_toggled)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	visible = !visible
	get_tree().paused = visible
	
	if visible:
		update_checkboxes()
		refresh_npcs()
		if pause_panel:
			pause_panel.visible = true
		if settings_panel:
			settings_panel.visible = false

func update_checkboxes() -> void:
	if not GameManager:
		return
	
	if minigame1_check:
		minigame1_check.button_pressed = GameManager.minigames_completed[0]
	if minigame2_check:
		minigame2_check.button_pressed = GameManager.minigames_completed[1]
	if minigame3_check:
		minigame3_check.button_pressed = GameManager.minigames_completed[2]

func refresh_npcs() -> void:
	var npcs = get_tree().get_nodes_in_group("npcs")
	for npc in npcs:
		if npc.has_method("update_npc_state"):
			npc.update_npc_state()

func recalculate_npc_index() -> void:
	# Find the first incomplete minigame (NPCs must be done in order)
	for i in range(GameManager.minigames_completed.size()):
		if not GameManager.minigames_completed[i]:
			# Found first incomplete - this is the active NPC
			GameManager.current_npc_index = i
			print("Minigames: ", GameManager.minigames_completed)
			print("First incomplete: NPC ", i)
			return
	
	# All minigames completed - go to final NPC (Mayor)
	GameManager.current_npc_index = 3
	print("All minigames complete! Go to Mayor (NPC 3)")

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_settings_pressed() -> void:
	if pause_panel:
		pause_panel.visible = false
	if settings_panel:
		settings_panel.visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/main/FarmHub.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_back() -> void:
	if pause_panel:
		pause_panel.visible = true
	if settings_panel:
		settings_panel.visible = false

func _on_reset_progress() -> void:
	GameManager.reset_game()
	update_checkboxes()
	refresh_npcs()

func _on_minigame1_toggled(toggled_on: bool) -> void:
	GameManager.minigames_completed[0] = toggled_on
	recalculate_npc_index()
	refresh_npcs()

func _on_minigame2_toggled(toggled_on: bool) -> void:
	GameManager.minigames_completed[1] = toggled_on
	recalculate_npc_index()
	refresh_npcs()

func _on_minigame3_toggled(toggled_on: bool) -> void:
	GameManager.minigames_completed[2] = toggled_on
	recalculate_npc_index()
	refresh_npcs()
