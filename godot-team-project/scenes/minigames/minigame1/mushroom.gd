#HASEGAWA REO
#plays the mushroom animation, detect when player touches the mushroom, applies slow effect to the player, play poison sound effect, make mushroom disappear after touch and after the sound finishes. 
extends Area2D

@export var slow_factor: float = 0.4
@export var slow_duration: float = 5.0

@onready var poison_sfx: AudioStreamPlayer2D = $PoisonSFX

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("mushroom")

func _on_body_entered(body: Node) -> void:
	if body.name != "Player" or not body.has_method("apply_slow"):
		return

	body.apply_slow(slow_duration, slow_factor)

	poison_sfx.play()

	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.visible = false

	await poison_sfx.finished
	queue_free()
