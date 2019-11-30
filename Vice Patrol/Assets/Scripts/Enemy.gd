extends RigidBody2D

var is_dead = false
func dead():
	is_dead = true
	$CollisionShape2D.disabled = true
	queue_free()



func _on_Big_Rock_Enemy_body_entered(body):
	if "Player" in body.name:
		body.dead()
		queue_free()
