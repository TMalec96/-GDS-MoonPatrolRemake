extends KinematicBody2D
#export (int) var life_time = 3
var velocity = Vector2()
var is_dead = false
export (int) var scoreValue = 100
export (float) var time_before_feint = 3
export (float) var boost_time_delay = 1
export (float) var boost_duration_time = 4
export (float) var boost_speed_value = 400
export (float) var life_time = 10
var is_jumped = false
var animationInstance = null
export (float) var animation_duration = 0.5
var animation = preload ("res://Scenes/EnemyAboveExplosionBulletAnimation.tscn")
onready var collision_detector = get_node("Collision_detector")
var stage1 = false #take player x velocity
var stage2 = false #forward movement
var stage2andhalf = false #backward movement
var stage3 = false #boost
var stage4 = false  #before boost
func _ready():
	animationInstance = animation.instance()
	add_child(animationInstance)
	animationInstance.visible = false
	animationInstance.playing = false
	$Sprite.animation = "start"
	$Sprite.playing = true
	stage1 = true
	yield(get_tree().create_timer(time_before_feint),"timeout")
	stage1 = false
	stage2 = true
	yield(get_tree().create_timer(1),"timeout")
	stage2 = false
	stage2andhalf = true
	yield(get_tree().create_timer(1),"timeout")
	stage2andhalf = false
	stage2 = true
	yield(get_tree().create_timer(1),"timeout")
	stage2 = false
	stage2andhalf = true
	yield(get_tree().create_timer(1),"timeout")
	stage2andhalf = false
	stage2 = true
	yield(get_tree().create_timer(1),"timeout")
	stage2 = false
	stage2andhalf = true
	yield(get_tree().create_timer(1),"timeout")
	stage2andhalf = false
	stage4 = true
	yield(get_tree().create_timer(boost_time_delay),"timeout") #boost
	stage4 = false
	stage3 = true
	yield(get_tree().create_timer(boost_duration_time),"timeout") # whileboosting
	stage3 = false
	stage1 = true
	yield(get_tree().create_timer(life_time),"timeout")
	queue_free()
	
func start_chase():
	if stage1:
		velocity = move_and_slide(Vector2(GlobalVariables.playerVelocity_x,0), Vector2(0, -1),5,4,rad2deg(75))
	elif stage2:
		velocity = move_and_slide(Vector2(GlobalVariables.playerVelocity_x+30,0), Vector2(0, -1),5,4,rad2deg(75))
	elif stage2andhalf:
		velocity = move_and_slide(Vector2(GlobalVariables.playerVelocity_x-30,0), Vector2(0, -1),5,4,rad2deg(75))
	elif stage3:
		velocity = move_and_slide(Vector2(GlobalVariables.playerVelocity_x+boost_speed_value,0), Vector2(0, -1),5,4,rad2deg(75))
		$Sprite.animation = "chase"
		$Sprite.playing = true
	elif stage4:
		velocity = move_and_slide(Vector2(GlobalVariables.playerVelocity_x-30,0), Vector2(0, -1),5,4,rad2deg(75))
	
	
	
func _physics_process(delta):
	start_chase()
	if collision_detector.is_colliding():
		collision_detector.get_collider().process_damage_enemy()
		dead()

func dead():
	is_dead = true
#	$CollisionShape2D.disabled = true
	GlobalVariables.playerScore += scoreValue
	queue_free()
func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true

	
	

