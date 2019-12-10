extends RigidBody2D

export (int) var projectile_speed = 400
export (int) var life_time = 3

func _ready():
	apply_impulse(Vector2(),Vector2(-projectile_speed,0).rotated(rotation))
	SelfDestruct()

func SelfDestruct():
	yield(get_tree().create_timer(life_time),"timeout")
	queue_free()



func _on_Bullet_body_entered(body):
	if "Player" in body.name:
		body.process_damage_enemy()
	queue_free()
func dead():
	queue_free()
