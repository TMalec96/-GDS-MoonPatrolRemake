extends StaticBody2D

export (float) var interval = 1
export (float) var colider_scale = 2
var is_dead = false
onready var collision_shape = get_node("CollisionShape2D")
onready var sprite = get_node("AnimatedSprite")
func _modify_collision_shape(interval):
	collision_shape.set_scale(Vector2(colider_scale,colider_scale))
	yield(get_tree().create_timer(interval), "timeout")
	collision_shape.set_scale(Vector2(1,1))
func _process(delta):
	_modify_collision_shape(interval)
func dead():
	is_dead = true
	$CollisionShape2D.disabled = true
	queue_free()