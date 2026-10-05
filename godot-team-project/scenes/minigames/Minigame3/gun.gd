extends Node2D

const BULLET = preload("res://scenes/minigames/Minigame3/Bullet.tscn")
func _process(delta):
	# Käännä ase kohti hiirtä
	look_at(get_global_mouse_position())

	# Ota rotaatio asteina 0–360
	var rot = wrapf(rotation_degrees, 0.0, 360.0)

	# Jos ase osoittaa vasemmalle päin (90–270 astetta)
	if rot > 90 and rot < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	
	if Input.is_action_just_pressed("Shoot"):
		var bullet = BULLET.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = rotation
		$AudioStreamPlayer2D.play()
