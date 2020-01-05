extends StaticBody2D

export (float) var interval = 1
export (float) var colider_scale = 2
export (int) var scoreValue = 100
export (bool) var is_destroyable = false
var is_jumped = false
var is_dead = false
var modyfing = false
onready var collision_shape = get_node("CollisionShape2D")
onready var anim = get_node("AnimatedSprite")


	
func _modify_collision_shape(interval):
	modyfing  = true
	$AnimatedSprite.playing =  true
	collision_shape.set_scale(Vector2(1,colider_scale))
	yield(get_tree().create_timer(interval), "timeout")
	collision_shape.set_scale(Vector2(1,1))
	$AnimatedSprite.playing =  false
	modyfing = false
	
func _process(delta):
	if !modyfing:
		_modify_collision_shape(interval)
func dead():
	if is_destroyable:
		is_dead = true
		GlobalVariables.playerScore += scoreValue
		queue_free()

func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true