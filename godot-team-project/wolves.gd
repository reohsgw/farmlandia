extends CharacterBody2D
class_name Enemy


@export var speed = 400
@onready var agent = $NavigationAgent2D
@onready var target = get_tree().get_nodes_in_group("Sheep")

func _ready()
	call_deferred("navi_setup")
	
func navi_setup()
	await get_tree()physics_frame
	
	$Timer.timeout.connect(set_movement_target)
	

func set_movement_target()
	agent.target_position = target.global.position
	
func _physics_process(delta):

	if(agent.is_navigation_finished()):
		return

	var next_path_position = agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	velocity = direction * speed
	move_and_slide()
