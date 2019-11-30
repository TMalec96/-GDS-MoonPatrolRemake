extends KinematicBody2D

var jump_speed = 200
export (int) var gravity = 1200


var velocity = Vector2()
var jumping = false

func get_input():
	
	var jump = Input.is_action_just_pressed('ui_up')
	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
		position.x = get_parent().get_position().x
		position.y = get_parent().get_position().y
		print_debug(position.x, position.y)
   

func _physics_process(delta):
    get_input()
    velocity.y += gravity * delta
    if jumping and is_on_floor():
        jumping = false
    velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(90))
