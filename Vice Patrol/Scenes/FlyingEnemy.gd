extends KinematicBody2D
var velocity = Vector2()

func start_chase(var velocity_x):
	velocity.x = velocity_x
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))