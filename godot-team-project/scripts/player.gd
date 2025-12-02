extends CharacterBody2D

# Top-down player controller with NPC interaction

@export var speed: float = 200.0

var can_interact: bool = false
var nearby_npc: Node = null


func _ready() -> void:
	# Add the player to an "interaction" group for easy identification
	add_to_group("player")


func _physics_process(_delta: float) -> void:
	# Get input direction
	var input_direction := Input.get_vector("left", "right", "up", "down")
	
	# Set velocity
	velocity = input_direction * speed
	
	# Move the character
	move_and_slide()
	
	# Update animation based on movement (you can expand this)
	update_animation(input_direction)


func _unhandled_input(event: InputEvent) -> void:
	# Check for interaction input (Space or Enter)
	if event.is_action_pressed("accept") and can_interact and nearby_npc:
		interact_with_npc()


func update_animation(direction: Vector2) -> void:
	# Placeholder for animation logic
	# You can add AnimatedSprite2D or AnimationPlayer here
	if direction.length() > 0:
		# Moving
		pass
	else:
		# Idle
		pass


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
