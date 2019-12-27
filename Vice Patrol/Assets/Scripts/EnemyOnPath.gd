extends KinematicBody2D
export (int) var scoreValue = 100
var can_fire = true
var is_dead = false
var is_jumped = false
var bullet1 = preload("res://Scenes/BulletEnemy_FlyingType1.tscn")
export (float) var rate_of_fire = 3
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
		var bullet_instanceFront = bullet1.instance()
		bullet_instanceFront.position = get_node("Position2D").get_position()
		get_parent().add_child(bullet_instanceFront)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true

