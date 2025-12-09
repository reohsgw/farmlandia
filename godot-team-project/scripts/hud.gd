extends CanvasLayer

@onready var progress_label = $TopPanel/HBoxContainer/ProgressLabel
@onready var objective_label = $TopPanel/HBoxContainer/ObjectiveLabel
@onready var timer_label = $TopPanel/HBoxContainer/TimerLabel

func _ready() -> void:
	update_hud()

func _process(_delta: float) -> void:
	update_hud()

func update_hud() -> void:
	if GameManager:
		var completed = GameManager.minigames_completed.count(true)
		var total = GameManager.minigames_completed.size()
		
		# Update progress
		progress_label.text = "Progress: %d/%d" % [completed, total]
		
		# Update objective
		var current_npc = GameManager.current_npc_index
		
		if current_npc == 0:
			objective_label.text = "Objective: Help Farmer Leevi"
		elif current_npc == 1:
			objective_label.text = "Objective: Help Farmer Lempi"
		elif current_npc == 2:
			objective_label.text = "Objective: Help Farmer Otto"
		elif current_npc == 3:
			objective_label.text = "Objective: Talk to the Mayor"
		else:
			objective_label.text = "Objective: Game Complete!"
		
		# Update timer
		if has_node("TopPanel/HBoxContainer/TimerLabel"):
			var time = GameManager.total_time_played
			var minutes = int(time) / 60
			var seconds = int(time) % 60
			timer_label.text = "Time: %02d:%02d" % [minutes, seconds]
