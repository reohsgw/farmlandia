extends Area2D

@export var slow_factor: float = 0.4
@export var slow_duration: float = 5.0

@onready var poison_sfx: AudioStreamPlayer2D = $PoisonSFX

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("mushroom")

func _on_body_entered(body: Node) -> void:
	# Only react to the Player once
	if body.name != "Player" or not body.has_method("apply_slow"):
		return

	# Apply slow effect
	body.apply_slow(slow_duration, slow_factor)

	# Play sound
	poison_sfx.play()

	# Disable further collisions and hide the mushroom
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.visible = false

	# Wait for the sound to finish, THEN free the node
	await poison_sfx.finished
	queue_free()
