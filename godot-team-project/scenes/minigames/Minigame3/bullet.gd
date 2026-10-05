extends Node2D

const speed = 300

func _physics_process(delta: float) -> void:
	position +=transform.x * speed * delta
	
	


func _on_hit_area_area_entered(area: Area2D) -> void:
	print("Bullet osui johonkin: ", area.name)
	print("Parent: ", area.get_parent().name if area.get_parent() else "ei parenttia")
	print("Onko wolves ryhmässä: ", area.is_in_group("wolves"))
	
	if area.is_in_group("wolves"):
		
		var wolf = area.get_parent()
		
		
		if wolf and wolf.has_method("take_damage"):
			
			wolf.take_damage()
		
		
		queue_free()
