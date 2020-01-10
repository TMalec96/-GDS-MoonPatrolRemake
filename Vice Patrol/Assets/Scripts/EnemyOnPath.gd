extends KinematicBody2D
export (int) var scoreValue = 100
var can_fire = true
var is_dead = false
var is_jumped = false
var bullet_normal = preload("res://Scenes/BulletEnemy_FlyingType1.tscn")
var bullet_bomb = preload ("res://Scenes/BulletEnemy_Flying_Bomb.tscn")
onready var ground_ray1 = get_node("RayCast2D")
onready var animation = preload("res://Scenes/PlayerDeathAnimation.tscn")
export (float) var animation_duration = 1
var animationInstance
export (float) var min_rate_of_fire = 3
export (float) var max_rate_of_fire = 6
export (bool) var is_bomber = false
func dead():
	_playAudio("res://Assets/Music/enemy_attack.wav") #smierc wroga
	is_dead = true
	$CollisionShape2D.disabled = true
	GlobalVariables.playerScore += scoreValue
	queue_free()
func _process(delta):
	if !is_dead and !GlobalVariables.is_player_respawning:
		FireLoop()
	if ground_ray1.is_colliding():
		is_dead = true
		$Sprite. visible = false
#		animationInstance.visible = true
#		animationInstance.playing = true
#		set_collision_layer_bit(9,false)
		_playAudio("res://Assets/Music/enemy_attack.wav") #smierc wroga
		yield(get_tree().create_timer(animation_duration),"timeout")
		queue_free()

func _ready():
	animationInstance = animation.instance()
	add_child(animationInstance)
	animationInstance.visible = false
	animationInstance.playing = false
	$Sprite. visible = false
	yield(get_tree().create_timer(0.2), "timeout")
	$Sprite. visible = true
	
func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true
func FireLoop():
	if 	can_fire:
		can_fire = false
		var time_delay_between_shoots = rand_range(min_rate_of_fire, max_rate_of_fire)
		var bullet_instance = null
		if !is_bomber:
			yield(get_tree().create_timer(time_delay_between_shoots), "timeout")
			bullet_instance = bullet_normal.instance()
		else:
			GlobalVariables.bomber_shoot_interval += time_delay_between_shoots
			yield(get_tree().create_timer(GlobalVariables.bomber_shoot_interval), "timeout")
			bullet_instance = bullet_bomb.instance()
		bullet_instance.position = get_node("Position2D").get_position()
		get_parent().add_child(bullet_instance)
		can_fire = true
func _playAudio(var patch):
	var music_file = patch
	var stream = AudioStream.new()
	var music_player =  get_node("AudioStream")
	var music = load(music_file)
	music_player.stream = music
	music_player.play()
