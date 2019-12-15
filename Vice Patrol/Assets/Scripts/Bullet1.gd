extends RigidBody2D

export (int) var projectile_speed = 400
export (int) var life_time = 3
export (bool) var is_up_bullet = false
var parent_speed = Vector2()

func Initialize(speed):
		parent_speed.x = speed
		
func _ready():
	if !is_up_bullet:
		apply_impulse(Vector2(0,0),Vector2(projectile_speed,0).rotated(rotation))
	else:
		apply_impulse(Vector2(0,0),Vector2(projectile_speed,parent_speed.x).rotated(rotation))
	SelfDestruct()

func SelfDestruct():
	yield(get_tree().create_timer(life_time),"timeout")
	queue_free()



func _on_Bullet_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
	queue_free()
