extends Node2D

var moles: Array = []

func _ready() -> void:
	# collect all moles
	for child in $Holes.get_children():
		moles.append(child)
		child.mole_hit.connect(_on_mole_hit)
	
	_schedule_next_mole()


func _schedule_next_mole() -> void:
	var t = get_tree().create_timer(1.0)   # wait 1 second
	t.timeout.connect(_spawn_random_mole)


func _spawn_random_mole() -> void:
	if moles.is_empty():
		return

	var mole = moles[randi() % moles.size()]
	mole.pop_up()              # 🔹 here the mole appears
	_schedule_next_mole()      # schedule another one


func _on_mole_hit() -> void:
	print("Hit!")
