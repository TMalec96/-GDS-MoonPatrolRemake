extends KinematicBody2D





var velocity = Vector2()

func _physics_process(delta):
	var gravity = get_parent().gravity
	velocity.y = delta*gravity
	
	
	
#	if jumping and is_on_floor():
#		 jumping = false	
	velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(90))
