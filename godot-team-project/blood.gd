extends AnimatedSprite2D

func _ready():
	play("Blood")                  # Käynnistää animaation
	await animation_finished        # Odottaa että animaatio loppuu
	queue_free()    
