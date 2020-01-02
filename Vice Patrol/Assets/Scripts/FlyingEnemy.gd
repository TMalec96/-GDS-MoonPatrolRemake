extends KinematicBody2D
var velocity = Vector2()
export (float) var duration_time = 15
var wave_ended = false

func _process(delta):
	if !wave_ended and !GlobalVariables.is_player_respawning:
		velocity.x = GlobalVariables.playerVelocity_x
		velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))
	elif GlobalVariables.is_player_respawning:
		queue_free()
func end_wave():
	yield(get_tree().create_timer(duration_time), "timeout")
	wave_ended = true
	velocity.x -=200
	yield(get_tree().create_timer(5), "timeout")
	queue_free()
	