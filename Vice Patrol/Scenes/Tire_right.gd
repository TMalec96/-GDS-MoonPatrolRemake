extends KinematicBody2D


export (int) var gravity = 1200


var velocity = Vector2()
var jumping = false   

func _physics_process(delta):
		
	velocity.y = get_parent().velocity.y
	
#	if jumping and is_on_floor():
#		 jumping = false	
	velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(90))