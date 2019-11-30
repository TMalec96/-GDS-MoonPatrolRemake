extends KinematicBody2D
export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200
export (int) var projectile_speed = 100

var velocity = Vector2()
var jumping = false

var bullet1 = preload("res://Scenes/BulletFront.tscn")
var bullet2 = preload("res://Scenes/BulletUp.tscn")
var can_fire =true
var rate_of_fire = 0.4


var is_dead = false




func _process(delta):
	FireLoop()
	
func get_input():
    velocity.x = 0
    var right = Input.is_action_pressed('ui_right')
    var left = Input.is_action_pressed('ui_left')
    var jump = Input.is_action_just_pressed('ui_up')

    if jump and is_on_floor():
        jumping = true
        velocity.y = jump_speed
    if right:
        velocity.x += run_speed
    if left:
        velocity.x -= run_speed

func _physics_process(delta):
	
    get_input()
    velocity.y += gravity * delta
    if jumping and is_on_floor():
        jumping = false
    velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(90))

func FireLoop():
	if Input.is_action_pressed("Shoot") and can_fire:
		can_fire = false
#		get_node("TurnAxis").rotation = get_angle_to(get_global_transform())
		var bullet_instanceFront = bullet1.instance()
		var bullet_instanceUp = bullet2.instance()
		bullet_instanceFront.position = get_node("TurnAxis/CastPoint1").get_global_position()
		bullet_instanceUp.position = get_node("TurnAxis/CastPoint2").get_global_position()
#		bullet_instance.rotation = get_global_rotation()
		get_parent().add_child(bullet_instanceFront)
		get_parent().add_child(bullet_instanceUp)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true
func dead():
	is_dead = true
	queue_free()


