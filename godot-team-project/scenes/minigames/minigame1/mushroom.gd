extends Area2D

@export var slow_factor: float = 0.4   
@export var slow_duration: float = 5.0 

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("mushroom")

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		if body.has_method("apply_slow"):
			body.apply_slow(slow_duration, slow_factor)
			queue_free()  
