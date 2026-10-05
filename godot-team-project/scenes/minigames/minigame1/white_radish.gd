#HASEGAWA REO
# plays the animation, detect when player touches the radish, give radish to the player, removes the radish from the scene. 

extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("whiteradish")

func _on_body_entered(body):
	if body.name == "Player":
		body.add_whiteradish(1)   
		queue_free()        
