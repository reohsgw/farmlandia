extends CharacterBody2D

@export var damage = 20
@export var speed: float = 100
@onready var agent = $NavigationAgent2D
@onready var anim = $AnimatedWolves

func _ready():
	if has_node("Area2D"):
		$Area2D.add_to_group("wolves")

	$Timer.start()
	$Timer.timeout.connect(set_movement_targets)
	set_movement_targets()
	anim.play("WolfWalk")

	add_to_group("wolves")

func set_movement_targets():
	var sheep_list = get_tree().get_nodes_in_group("Sheep")
	if sheep_list.is_empty():
		return

	var target = sheep_list[randi() % sheep_list.size()]
	agent.target_position = target.global_position

func _physics_process(delta):
	# Jos navigaatio on valmis → pysähdy
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	# Hae seuraava reittipiste
	var next_pos = agent.get_next_path_position()
	var dir = global_position.direction_to(next_pos)

	# Aseta nopeus
	velocity = dir * speed
	move_and_slide()

	# Käännä susi oikeaan suuntaan
	if velocity.x > 0:
		anim.flip_h = true
	elif velocity.x < 0:
		anim.flip_h = false

func take_damage():
	print("Susi kuoli!")

	var game = get_tree().current_scene
	if game and game.has_method("wolf_shot"):
		game.wolf_shot()

	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		get_node("/root/Minigame3").wolf_shot()
		queue_free()
