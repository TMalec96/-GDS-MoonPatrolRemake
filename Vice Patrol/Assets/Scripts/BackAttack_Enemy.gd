extends KinematicBody2D
export (int) var life_time = 3
var velocity = Vector2()
var is_spawned = false
var max_speed = 0
var boost_delay_time = 1
var is_dead = false
export (int) var scoreValue = 100
export (float) var enemy_boost_time_delay = 3
export (float) var boost_duration_time = 1.5
export (float) var boost_speed_value = 500
var is_jumped = false
onready var collision_detector = get_node("Collision_detector")

func _ready():
	start_chase()
func start_chase():
	velocity.x = GlobalVariables.playerVelocity_x
	boost_delay_time = enemy_boost_time_delay
	yield(get_tree().create_timer(boost_delay_time),"timeout")
	velocity.x += boost_speed_value
	$Sprite.animation = "active"
	yield(get_tree().create_timer(boost_duration_time),"timeout")
	velocity.x = GlobalVariables.playerVelocity_x
	
	
func _physics_process(delta):
	
	velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))
	if collision_detector.is_colliding():
		collision_detector.get_collider().process_damage_enemy()
		dead()

func dead():
	is_dead = true
#	$CollisionShape2D.disabled = true
	GlobalVariables.playerScore += scoreValue
	queue_free()
func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true

	
	

