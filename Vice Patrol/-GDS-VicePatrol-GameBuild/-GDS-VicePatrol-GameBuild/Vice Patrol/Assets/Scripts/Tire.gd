extends KinematicBody2D

var jump_speed = -200
export (int) var gravity = 1200


var velocity = Vector2()




   

func _physics_process(delta):
	velocity.x = 0
	velocity.y += gravity * delta
#		print(get_parent().get_global_position().x)
#		print(position.x)
#		position.x = get_parent().get_global_position().x
		
	velocity = move_and_slide(velocity, Vector2(0,-1),5,4,rad2deg(90))

