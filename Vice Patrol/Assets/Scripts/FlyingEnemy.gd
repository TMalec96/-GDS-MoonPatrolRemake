extends KinematicBody2D
var velocity = Vector2()
export (float) var duration_time = 5

func _process(delta):
	if !GlobalVariables.is_player_respawning:
		velocity.x = GlobalVariables.playerVelocity_x
		velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))
	else:
		queue_free()
	