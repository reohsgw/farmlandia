extends Area2D



var heal_amount: int = 25

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Heal the player
		body.heal(heal_amount)
		# Remove potion from scene
		queue_free()
