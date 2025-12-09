extends CanvasLayer

# References
var pause_panel: Panel
var settings_panel: Panel
var volume_slider: HSlider
var minigame1_check: CheckBox
var minigame2_check: CheckBox
var minigame3_check: CheckBox

func _ready() -> void:
	# Start hidden
	visible = false
	
	# Get all references safely
	pause_panel = $PausePanel if has_node("PausePanel") else null
	settings_panel = $SettingsPanel if has_node("SettingsPanel") else null
	volume_slider = $SettingsPanel/VBoxContainer/VolumeSlider if has_node("SettingsPanel/VBoxContainer/VolumeSlider") else null
	minigame1_check = $SettingsPanel/VBoxContainer/Minigame1Check if has_node("SettingsPanel/VBoxContainer/Minigame1Check") else null
	minigame2_check = $SettingsPanel/VBoxContainer/Minigame2Check if has_node("SettingsPanel/VBoxContainer/Minigame2Check") else null
	minigame3_check = $SettingsPanel/VBoxContainer/Minigame3Check if has_node("SettingsPanel/VBoxContainer/Minigame3Check") else null
	
	# Connect buttons
	connect_buttons()
	
	# Load volume
	load_volume()
	
	# Hide settings panel
	if settings_panel:
		settings_panel.visible = false

func connect_buttons() -> void:
	# Pause panel buttons
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
	
	# Volume slider
	if volume_slider:
		volume_slider.value_changed.connect(_on_volume_changed)
	
	# Settings panel buttons
	if has_node("SettingsPanel/VBoxContainer/BackButton"):
		$SettingsPanel/VBoxContainer/BackButton.pressed.connect(_on_settings_back)
	
	if has_node("SettingsPanel/VBoxContainer/ResetProgressButton"):
		$SettingsPanel/VBoxContainer/ResetProgressButton.pressed.connect(_on_reset_progress)
	
	# Checkboxes
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

func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func load_volume() -> void:
	if not volume_slider:
		return
	
	var current_db = AudioServer.get_bus_volume_db(0)
	var current_volume = db_to_linear(current_db) * 100.0
	volume_slider.value = current_volume

func _on_settings_back() -> void:
	if pause_panel:
		pause_panel.visible = true
	if settings_panel:
		settings_panel.visible = false

func _on_reset_progress() -> void:
	GameManager.reset_game()
	update_checkboxes()

func _on_minigame1_toggled(toggled_on: bool) -> void:
	GameManager.minigames_completed[0] = toggled_on
	if toggled_on and GameManager.current_npc_index == 0:
		GameManager.current_npc_index = 1

func _on_minigame2_toggled(toggled_on: bool) -> void:
	GameManager.minigames_completed[1] = toggled_on
	if toggled_on and GameManager.current_npc_index == 1:
		GameManager.current_npc_index = 2

func _on_minigame3_toggled(toggled_on: bool) -> void:
	GameManager.minigames_completed[2] = toggled_on
	if toggled_on and GameManager.current_npc_index == 2:
		GameManager.current_npc_index = 3
