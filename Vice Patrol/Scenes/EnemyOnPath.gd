extends KinematicBody2D
export (int) var scoreValue = 100

var is_dead = false
var is_jumped = false
func dead():
	is_dead = true
	$CollisionShape2D.disabled = true
	GlobalVariables.playerScore += scoreValue
	queue_free()

func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true

