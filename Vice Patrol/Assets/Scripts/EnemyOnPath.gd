extends KinematicBody2D
export (int) var scoreValue = 100
var can_fire = true
var is_dead = false
var is_jumped = false
var bullet_normal = preload("res://Scenes/BulletEnemy_FlyingType1.tscn")
var bullet_bomb = preload ("res://Scenes/BulletEnemy_Flying_Bomb.tscn")
export (float) var min_rate_of_fire = 3
export (float) var max_rate_of_fire = 6
export (bool) var is_bomber = false
func dead():
	is_dead = true
	$CollisionShape2D.disabled = true
	GlobalVariables.playerScore += scoreValue
	queue_free()
func _process(delta):
	FireLoop()

func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true
func FireLoop():
	if 	can_fire:
		can_fire = false
		var time_delay_between_shoots = rand_range(min_rate_of_fire, max_rate_of_fire)
		GlobalVariables.bomber_shoot_interval += time_delay_between_shoots
		yield(get_tree().create_timer(GlobalVariables.bomber_shoot_interval), "timeout")
		var bullet_instance = null
		if !is_bomber:
			bullet_instance = bullet_normal.instance()
		else:
			bullet_instance = bullet_bomb.instance()
		bullet_instance.position = get_node("Position2D").get_position()
		get_parent().add_child(bullet_instance)
		can_fire = true

