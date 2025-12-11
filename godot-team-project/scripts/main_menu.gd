# Tatu Nyberg
extends Control

func _ready():
	print("Menu loaded!")
	
	# Connect main menu buttons
	connect_button("MenuButtons/StartButton", _on_start_pressed)
	connect_button("MenuButtons/ExitButton", _on_exit_pressed)
	connect_button("MenuButtons/StoryButton", _on_story_pressed)
	connect_button("MenuButtons/OptionsButton", _on_options_pressed)
	connect_button("MenuButtons/CreditsButton", _on_credits_pressed)
	
	# Connect panel close buttons
	connect_button("StoryPanel/VBoxContainer/StoryCloseButton", _on_story_close)
	connect_button("OptionsPanel/VBoxContainer/OptionsCloseButton", _on_options_close)
	connect_button("CreditsPanel/VBoxContainer/CreditsCloseButton", _on_credits_close)
	
	# Connect volume slider
	if has_node("OptionsPanel/VBoxContainer/VolumeSlider"):
		$OptionsPanel/VBoxContainer/VolumeSlider.value_changed.connect(_on_volume_changed)
	
	# Hide all panels at start
	hide_all_panels()

func connect_button(path: String, callback: Callable):
	if has_node(path):
		get_node(path).pressed.connect(callback)
		print("Connected: ", path)
	else:
		print("NOT FOUND: ", path)

func hide_panel(path: String):
	if has_node(path):
		get_node(path).visible = false

func show_panel(path: String):
	hide_all_panels()
	if has_node(path):
		get_node(path).visible = true

func hide_all_panels():
	hide_panel("StoryPanel")
	hide_panel("OptionsPanel")
	hide_panel("CreditsPanel")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main/FarmHub.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_story_pressed():
	show_panel("StoryPanel")

func _on_options_pressed():
	show_panel("OptionsPanel")

func _on_credits_pressed():
	show_panel("CreditsPanel")

func _on_story_close():
	hide_panel("StoryPanel")

func _on_options_close():
	hide_panel("OptionsPanel")

func _on_credits_close():
	hide_panel("CreditsPanel")

func _on_volume_changed(value: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))
	print("Volume: ", value, "%")
