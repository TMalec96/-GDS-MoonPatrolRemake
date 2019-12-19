extends KinematicBody2D
var velocity = Vector2()


func _physics_process(delta):
	velocity.x = GlobalVariables.playerVelocity_x
	velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))