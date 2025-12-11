#HASEGAWA REO
extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("carrot")

func _on_body_entered(body):
	if body.name == "Player":
		body.add_carrot(1)   
		queue_free()        
