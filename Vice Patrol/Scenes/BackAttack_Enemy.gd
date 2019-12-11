extends KinematicBody2D
 
export (int) var speed = 400
export (int) var life_time = 3
var velocity = Vector2()
var is_spawned = false
var max_speed = 0
var boost_delay_time = 0
var is_dead = false

func start_chase(velocity_x,max_player_speed,enemy_boost_time_delay, boost_duration_time):
	velocity.x = velocity_x
	max_speed = max_player_speed
	boost_delay_time = enemy_boost_time_delay
	yield(get_tree().create_timer(boost_delay_time),"timeout")
	velocity.x = max_speed + 200
	yield(get_tree().create_timer(boost_duration_time),"timeout")
	velocity.x = velocity_x
	
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))

func dead():
	is_dead = true
	$CollisionShape2D.disabled = true
	queue_free()
	
	

