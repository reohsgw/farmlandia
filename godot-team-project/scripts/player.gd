extends CharacterBody2D

# Top-down player controller with NPC interaction

@export var speed: float = 200.0

var last_direction: Vector2 = Vector2.DOWN

var can_interact: bool = false
var nearby_npc: Node = null


func _ready() -> void:
	# Add the player to an "interaction" group for easy identification
	add_to_group("player")


func _physics_process(delta: float) -> void:
	# Get input direction
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# Update animation based on direction
	update_animation(direction)
	
	# Movement
	if direction:
		velocity = direction * speed
		last_direction = direction  # Remember last direction
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	move_and_slide()

func update_animation(direction: Vector2) -> void:
	if not has_node("AnimatedSprite2D"):
		return
	
	var anim_sprite = $AnimatedSprite2D
	
	if direction.length() > 0:
		# Moving
		if abs(direction.x) > abs(direction.y):
			# Moving horizontally
			anim_sprite.play("walk_left")  # Always play walk_right
			
			if direction.x > 0:
				anim_sprite.flip_h = true  # Moving right, normal
			else:
				anim_sprite.flip_h = false   # Moving left, flip it!
		else:
			# Moving vertically
			anim_sprite.flip_h = false  # Reset flip for up/down
			
			if direction.y > 0:
				anim_sprite.play("walk_down")
			else:
				anim_sprite.play("walk_up")
	else:
		# Idle
		anim_sprite.stop()


func _unhandled_input(event: InputEvent) -> void:
	# Check for interaction input (Space or Enter)
	if event.is_action_pressed("accept") and can_interact and nearby_npc:
		interact_with_npc()


func interact_with_npc() -> void:
	if nearby_npc and nearby_npc.has_method("interact"):
		nearby_npc.interact()


func _on_interaction_area_entered(area: Area2D) -> void:
	# When entering an NPC's interaction area
	if area.is_in_group("npc_interaction"):
		can_interact = true
		nearby_npc = area.get_parent()
		print("Near NPC - Press Space/Enter to interact")


func _on_interaction_area_exited(area: Area2D) -> void:
	# When leaving an NPC's interaction area
	if area.is_in_group("npc_interaction"):
		can_interact = false
		nearby_npc = null
		print("Left NPC area")
