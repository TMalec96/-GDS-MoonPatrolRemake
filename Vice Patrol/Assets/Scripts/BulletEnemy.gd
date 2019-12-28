extends RigidBody2D

export (int) var projectile_speed = 400
export (int) var life_time = 3
export (bool) var direction_down = false
onready var sprite = get_node("Sprite")
onready var collider = get_node("CollisionShape2D")
var animation = preload ("res://Scenes/EnemyAboveExplosionBulletAnimation.tscn")
var was_exploded = false
func _ready():
	if !direction_down:
		apply_impulse(Vector2(),Vector2(-projectile_speed,0).rotated(rotation))
	else:
		var xvelocity = GlobalVariables.playerVelocity_x+randi()%51-100
		apply_impulse(Vector2(),Vector2(xvelocity,projectile_speed).rotated(rotation))
	var animationInstance = animation.instance()
	animationInstance.position = get_position()
	add_child(animationInstance)
	SelfDestruct()

func SelfDestruct():
	yield(get_tree().create_timer(life_time),"timeout")
	queue_free()
	
func dead():
	queue_free()


func _on_BulletEnemy_FlyingType1_body_entered(body):
	if "Player" in body.name:
		body.process_damage_enemy()
#	queue_free()
