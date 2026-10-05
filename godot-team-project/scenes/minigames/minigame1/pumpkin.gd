#HASEGAWA REO
# plays the animation, detect when player touches the pumpkin, give pumpkin to the player, removes the pumpkin from the scene. 

extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("pumpkin")

func _on_body_entered(body):
	if body.name == "Player":
		body.add_pumpkin(1)   
		queue_free()        
