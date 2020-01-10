extends StaticBody2D

export (int) var scoreValue = 100
export (bool) var is_destroyable = false
export (float) var animation_duration = 0.5
var is_dead = false
var is_jumped = false
export (bool) var is_rock = false
var animation = preload ("res://Scenes/EnemyAboveExplosionBulletAnimation.tscn")
var animationInstance = null
func _ready():
	if is_destroyable:
		animationInstance = animation.instance()
		animationInstance.position.y +=5
		add_child(animationInstance)
		animationInstance.visible = false
		animationInstance.playing = false
func dead():
	set_collision_mask_bit(0,false)
	if is_destroyable:
		hide()
		animationInstance.visible = true
		animationInstance.playing = true
		set_collision_layer_bit(9,false)
		is_dead = true
		GlobalVariables.playerScore += scoreValue
		_playAudio("res://Assets/Music/enemy_dead.wav") #smierc wroga
		yield(get_tree().create_timer(animation_duration),"timeout")
		queue_free()

func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true
func hide():
	$Sprite.visible = false
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(4,false)
	$CollisionShape2D.disabled = true
func show():
	$Sprite.visible = true
	set_collision_mask_bit(0,true)

func _playAudio(var patch):
	var music_file = patch
	var stream = AudioStream.new()
	var music_player =  get_node("AudioStream")
	var music = load(music_file)
	music_player.stream = music
	music_player.play()