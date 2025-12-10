extends CharacterBody2D

# Top-down player controller with NPC interaction

@export var speed: float = 200.0
var normal_speed: float 
var last_direction: Vector2 = Vector2.DOWN

var can_interact: bool = false
var nearby_npc: Node = null

#minigame1
signal carrot_collected(new_value)
var carrots_collected := 0
signal whiteradish_collected(new_value)
var whiteradishes_collected := 0
signal pumpkin_collected(new_value)
var pumpkins_collected := 0

signal player_won
signal player_missing_items

@onready var slow_timer: Timer = $SlowTimer
@onready var blink_timer: Timer = $BlinkTimer
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Add the player to an "interaction" group for easy identification
	add_to_group("player")
	if speed <= 0.0:
		speed = 200.0   # fallback if Inspector has 0
	normal_speed = speed


func _physics_process(delta: float) -> void:
	# Get input direction
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# Update animation based on direction
	update_animation(direction)
	
	# Movement
	if direction:
		velocity = direction * speed
		last_direction = direction
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

#minigame(HASEGAWA REO) 
func add_carrot(amount):
	carrots_collected += amount
	print("Carrot collected! Total =", carrots_collected)
	carrot_collected.emit(carrots_collected)
	
func add_whiteradish(amount):
	whiteradishes_collected += amount
	print("white radish collected! Total =", whiteradishes_collected)
	whiteradish_collected.emit(whiteradishes_collected)

func add_pumpkin(amount):
	pumpkins_collected += amount
	print("pumpkin collected! Total =", pumpkins_collected)
	pumpkin_collected.emit(pumpkins_collected)
	
func apply_slow(duration: float = 5.0, slow_speed: float = 80.0) -> void:
	speed = slow_speed
	slow_timer.start(duration)
	blink_timer.start()

func _on_slow_timer_timeout() -> void:
	print("Timer timeout! Reset speed to:", normal_speed)
	speed = normal_speed
	blink_timer.stop()    
	if anim_sprite:
		anim_sprite.visible = true 

func _on_blink_timer_timeout() -> void:
	if anim_sprite:
		anim_sprite.visible = not anim_sprite.visible

func check_win_condition():
	if carrots_collected >= 7 and whiteradishes_collected >= 5 and pumpkins_collected >= 3:
		emit_signal("player_won")
	else:
		emit_signal("player_missing_items")
