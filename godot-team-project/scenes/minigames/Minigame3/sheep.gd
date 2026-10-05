extends CharacterBody2D
class_name AnimatedSheep

@onready var animated_sprite = $AnimatedSheep

@onready var eatTimer = $Timer
@onready var Sheep_label = $"../CanvasLayer/Sheep"

@export var speed = 50
@export var left_limit = -100			
@export var right_limit = 100.0
@export var health = 100	

var sheep_count = 7

	
var direction = 1   
var start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	start_position = global_position
	animated_sprite.play('WolfWalk')
	
	
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(4, true)  
	set_collision_mask_value(1, true)  
	
	
	
	
	
	for child in get_children():
		if child is Area2D:
			
			
			
			child.collision_mask = 0
			child.set_collision_mask_value(3, true)  
			child.monitoring = true
			child.monitorable = true
			
			
			if not child.body_entered.is_connected(_on_body_entered):
				child.body_entered.connect(_on_body_entered)
				
			break
	
	eatTimer.wait_time = 120
	eatTimer.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("wolves"):
		# Hae pelin pääscene
		var game = get_tree().current_scene
		if game.has_method("sheep_eaten"):
			game.sheep_eaten()
			queue_free()

func _physics_process(_delta: float) -> void:
	velocity.x = direction * speed
	move_and_slide()
	
	if velocity.x != 0:
		animated_sprite.play("default")
		animated_sprite.flip_h = direction == 1
	else:
		animated_sprite.play("idle")
	
	var distance_from_start = global_position.x - start_position.x
	if distance_from_start > right_limit:
		direction = -1
	elif distance_from_start < left_limit:
		direction = 1
		
func _on_EatTimer_timeout() -> void:
	direction = 1
