extends Node2D

@export var mushroom_scene: PackedScene
var spawn_points: Array[Marker2D] = []

func _ready() -> void:
	randomize()
	# collect all Marker2D children as spawn points
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)
	_spawn_loop()

func _spawn_loop() -> void:
	# continuous loop
	while true:
		var wait_time = randf_range(3.0, 7.0)
		await get_tree().create_timer(wait_time).timeout
		_spawn_mushroom()

func _spawn_mushroom() -> void:
	if spawn_points.is_empty() or mushroom_scene == null:
		return

	var spawn_marker := spawn_points[randi() % spawn_points.size()]
	var mushroom := mushroom_scene.instantiate()
	mushroom.global_position = spawn_marker.global_position
	get_tree().current_scene.add_child(mushroom)
