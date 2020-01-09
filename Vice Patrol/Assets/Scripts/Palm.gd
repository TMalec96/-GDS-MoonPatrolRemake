extends StaticBody2D

export (float) var interval = 1
export (float) var colider_scale = 2
export (int) var scoreValue = 100
var is_jumped = false
var is_dead = false
var modyfing = false
var animationInstance = null
export (float) var animation_duration = 0.5
onready var collision_shape = get_node("CollisionShape2D")
onready var anim = get_node("AnimatedSprite")
var animation = preload ("res://Scenes/EnemyAboveExplosionBulletAnimation.tscn")
func _ready():
	animationInstance = animation.instance()
	add_child(animationInstance)
	animationInstance.visible = false
	animationInstance.playing = false
	
func _modify_collision_shape(interval):
	modyfing  = true
	$AnimatedSprite.playing =  true
	collision_shape.set_scale(Vector2(1,colider_scale))
	yield(get_tree().create_timer(interval), "timeout")
	collision_shape.set_scale(Vector2(1,1))
	$AnimatedSprite.playing =  false
	modyfing = false
	
func _process(delta):
	if !modyfing:
		_modify_collision_shape(interval)
func hide():
	$Sprite.visible = false
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(4,false)
	$CollisionShape2D.disabled = true
func dead():
	set_collision_mask_bit(0,false)
	hide()
	animationInstance.visible = true
	animationInstance.playing = true
	animationInstance.scale =Vector2(2,2)
	set_collision_layer_bit(9,false)
	is_dead = true
	GlobalVariables.playerScore += scoreValue
	yield(get_tree().create_timer(animation_duration),"timeout")
	queue_free()

func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true