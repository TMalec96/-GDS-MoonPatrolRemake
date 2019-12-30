extends RigidBody2D

export (int) var projectile_speed = 400
export (int) var life_time = 3
export (bool) var is_up_bullet = false
var parent_speed = Vector2()
export (float) var animation_duration = 0.3
var animation = preload ("res://Scenes/PlayerFrontExplosionBulletAnimation.tscn")
var animationInstance = null
func Initialize(speed):
		parent_speed.x = speed
		
func _ready():
	if !is_up_bullet:
		apply_impulse(Vector2(0,0),Vector2(projectile_speed,0).rotated(rotation))
		animationInstance = animation.instance()
		add_child(animationInstance)
		animationInstance.visible = false
		animationInstance.playing = false
		yield(get_tree().create_timer(life_time),"timeout")
		SelfDestructWithAnimation()
	else:
		apply_impulse(Vector2(0,0),Vector2(projectile_speed,parent_speed.x).rotated(rotation))
		yield(get_tree().create_timer(life_time),"timeout")
		SelfDestruct()

func SelfDestruct():
	queue_free()
func SelfDestructWithAnimation():
	$Sprite.visible = false
	animationInstance.visible = true
	animationInstance.playing = true
	apply_impulse(Vector2(0,0),Vector2(-projectile_speed,0).rotated(rotation))
	yield(get_tree().create_timer(animation_duration),"timeout")
	queue_free()


func _on_Bullet_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
	queue_free()
