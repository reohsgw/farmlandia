extends CharacterBody2D
class_name AnimatedSheep
@onready var animated_sprite = $AnimatedSheep
@onready var eatTimer = $EatTimer

@export var speed = 100
@export var left_limit = -100		
@export var right_limit = 100.0
@export var health = 100	
var direction = 1   
var start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	start_position = global_position
	animated_sprite.play('idle')
	
	eatTimer.wait_time = 120
	eatTimer.start()
	
	
	
func _physics_process(_delta: float) -> void:
	velocity.x = direction * speed
	move_and_slide()
	# Käynnistä animaatio
	if velocity.x != 0:
		animated_sprite.play("default")
		# Jos animaatio piirretty oikealle päin:
		animated_sprite.flip_h = direction == 1
	else:
		animated_sprite.play("idle")   # näyttää ekan framen
	# Check patrol limits
	var distance_from_start = global_position.x - start_position.x
	if distance_from_start > right_limit:
		direction = -1
	elif distance_from_start < left_limit:
		direction = 1
		
func _on_EatTimer_timeout() -> void:
	# Kun syömisaika loppuu, lammas lähtee kävelemään
	direction = 1   # aloitetaan oikealle


	
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("wolves"):
		print("Susi osui lampaaseen!")
		queue_free()
