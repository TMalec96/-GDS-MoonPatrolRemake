extends KinematicBody2D
#PLAYER MOVEMENT
onready var ground_ray1 = get_node("groundray1")
onready var ground_ray2 = get_node("groundray2")
export (int) var min_player_speed = 250 #Player speed
export (int) var avg_player_speed = 350
export (int) var max_player_speed = 500
export (int) var jump_speed = 600
export (int) var gravity = 1200
export (float) var speed_incrementation_sec = 1.5

var velocity = Vector2()
var jumping = false

var game_begening = true
#CAMERA MOVEMENT
onready var camera = get_node("Camera2D")
export(float) var camera_offset_drag_right = 200
export(float) var camera_offset_drag_left = 400
var camera_drag_speed = speed_incrementation_sec/1.5

#BACK ATTACKING ENEMY
var back_enemy = preload("res://Scenes/BackAttack_Enemy.tscn")

#PLAYER SHOOTING
var bullet1 = preload("res://Scenes/BulletFront.tscn")
var bullet2 = preload("res://Scenes/BulletUp.tscn")
var can_fire_front =true
var can_fire_up =true
export (float) var rate_of_fire_front = 0.4
export (float) var rate_of_fire_up = 0.1

#PLAYER SCORING
onready var enemy_detector_ray = get_node("EnemyDetector")

#PLAYER LIFES
export (int) var lifes = 3
export (float) var respawn_delay = 3.0

#FLYING ENEMIES
var flying_enemy_1 = preload("res://Scenes/Flying_Enemy_1.tscn")
var flying_enemy_2 = preload("res://Scenes/Flying_Enemy_2.tscn")
var flying_enemy_3 = preload("res://Scenes/Flying_Enemy_3.tscn")

#INTERFACE WARNINGS
onready var interface = get_node("Canvas/Interface")
#DEATH ANIMATION
onready var animation = preload("res://Scenes/PlayerDeathAnimation.tscn")
var animationInstance
func _ready():
	GlobalVariables.is_player_respawning = false
	if GlobalVariables.god_mode:
		set_collision_layer_bit(0,false)
		
		set_collision_mask_bit(4,false)
#	velocity.x = 350
	camera.offset.x = 300
	GlobalVariables.playerLifes = lifes
	GlobalVariables.paused = false
	animationInstance = animation.instance()
	add_child(animationInstance)
	animationInstance.playing = false
	animationInstance.visible = false
func _respawn():
	position.x -=50
	GlobalVariables.paused = true
	velocity.x = 0
	velocity.y = 0
	_playAudio("res://Assets/Music/wybuch_gracza.wav") # wybuch gracza
	get_node("Tire_left").visible =false
	get_node("Tire_right").visible =false
	animationInstance.playing = true
	animationInstance.visible = true
	$Sprite.visible = false
	yield(get_tree().create_timer(respawn_delay),"timeout")
	get_node("Tire_left").visible =true
	get_node("Tire_right").visible =true
	$Sprite.visible = true
	position = GlobalVariables.respawn_position
	_set_wheels_position_global()
	animationInstance.playing = false
	animationInstance.visible = false
	yield(get_tree().create_timer(1),"timeout")
	GlobalVariables.is_player_respawning = false
	GlobalVariables.paused = false
	velocity.x = 350
func _process(delta):
	if game_begening:
		yield(get_tree().create_timer(2),"timeout")
	if !GlobalVariables.is_player_respawning:
		FireLoopUp()
		FireLoopFront()	
func get_input():
		var right_pressed = Input.is_action_pressed('ui_right')
		var right_released = Input.is_action_just_released('ui_right')
		var left_released = Input.is_action_just_released('ui_left')
		var left_pressed = Input.is_action_pressed('ui_left')
		var jump = Input.is_action_just_pressed('ui_up')
		if jump and (ground_ray1.is_colliding() or ground_ray2.is_colliding()):
			jumping = true
			velocity.y = -jump_speed
			_set_wheels_position_global()
			_playAudio("res://Assets/Music/jump.wav") #skok
			jumping = false	
		if right_pressed:
			if(velocity.x <= max_player_speed):
				velocity.x +=speed_incrementation_sec
			else:
				velocity.x = max_player_speed
			if camera.offset.x>=camera_offset_drag_right:
					camera.offset.x -= camera_drag_speed
		if left_pressed:
			if(velocity.x >= min_player_speed):
				velocity.x -= speed_incrementation_sec
			else:
				velocity.x = min_player_speed
			if camera.offset.x <= camera_offset_drag_left:
					camera.offset.x += camera_drag_speed
		if !right_pressed and !left_pressed:
			if(velocity.x <= avg_player_speed):
				velocity.x += speed_incrementation_sec
			elif(velocity.x >= avg_player_speed):
				velocity.x -= speed_incrementation_sec
			if(camera.offset.x >= 300):
					camera.offset.x -= camera_drag_speed
			if(camera.offset.x <= 300):
					camera.offset.x += camera_drag_speed
func _physics_process(delta):
	if game_begening:
		yield(get_tree().create_timer(2),"timeout")
	_process_score()
	if !GlobalVariables.is_player_respawning:
		get_input()
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2(0, -1))
		for i in range(get_slide_count() - 1):
	#		ZAMIENIC NA FUNKCJE
			var collision = get_slide_collision(i)
			process_damage(collision)
	_set_wheels_position_x()
	GlobalVariables.playerVelocity_x = velocity.x
func _process_score():
	if enemy_detector_ray.is_colliding():
		enemy_detector_ray.get_collider().countScore()		
func _set_wheels_position_global():
	var wheel_right_position = get_node("TiresPosition/RightTire").get_position()
	var wheel_left_position = get_node("TiresPosition/LeftTire").get_position()
	var left_tire = get_node("Tire_left")
	var right_tire = get_node("Tire_right")
	left_tire.position = wheel_left_position
	right_tire.position = wheel_right_position
func _set_wheels_position_x():
	var wheel_right_position = get_node("TiresPosition/RightTire").get_position().x
	var wheel_left_position = get_node("TiresPosition/LeftTire").get_position().x
	var left_tire = get_node("Tire_left")
	var right_tire = get_node("Tire_right")
	left_tire.position.x = wheel_left_position
	right_tire.position.x = wheel_right_position
func FireLoopUp():
	if Input.is_action_just_pressed("Shoot") and can_fire_up:
		can_fire_up = false
		var bullet_instanceUp = bullet2.instance()
		bullet_instanceUp.position = get_node("TurnAxis/CastPoint2").get_global_position()
		bullet_instanceUp.Initialize(velocity.x)
		get_parent().add_child(bullet_instanceUp)
		yield(get_tree().create_timer(rate_of_fire_up), "timeout")
		can_fire_up = true
func FireLoopFront():
	if Input.is_action_just_pressed("Shoot") and can_fire_front:
		can_fire_front = false
		var bullet_instanceFront = bullet1.instance()
		bullet_instanceFront.position = get_node("TurnAxis/CastPoint1").get_global_position()
		get_parent().add_child(bullet_instanceFront)
		yield(get_tree().create_timer(rate_of_fire_front), "timeout")
		can_fire_front = true
func dead():
	visible = false
	position.y+=10
	SceneLoader.goto_scene("res://Scenes/GameOverScene.tscn")
#OPTYMALIZACJA FUNKCJI
func process_damage(var collision):
	if "Enemy" in collision.collider.name:
		GlobalVariables.playerLifes -= 1
		GlobalVariables.is_player_respawning = true
		if !"Rock" in collision.collider.name:
			collision.collider.dead()
		_respawn()
		if GlobalVariables.playerLifes<= 0:
			yield(get_tree().create_timer(3), "timeout")
			dead()
func process_damage_enemy():
	GlobalVariables.playerLifes -= 1
	GlobalVariables.is_player_respawning = true
	_respawn()
	if GlobalVariables.playerLifes<= 0:
		yield(get_tree().create_timer(3), "timeout")
		dead()
func spawn_enemies(var spawn_position, var enemy_type, var number_of_enemies, var delay_between_spawns, var time_delay, var caution_direction, var spawning):
	create_warning(caution_direction,time_delay)
	yield(get_tree().create_timer(time_delay), "timeout")
	_playAudio("res://Assets/Music/enemy_attack.wav") #spawnowanie wrogow
	if spawning:
		for i in range(number_of_enemies):
			if !GlobalVariables.is_player_respawning:
				var enemy_instance =flying_enemy_1.instance()
				if enemy_type ==GlobalVariables.EnemyType.Enemy_type1:
					enemy_instance= flying_enemy_1.instance()
				elif enemy_type == GlobalVariables.EnemyType.Enemy_back:
					enemy_instance = back_enemy.instance()
				elif enemy_type ==GlobalVariables.EnemyType.Enemy_type2:
					enemy_instance= flying_enemy_2.instance()
				elif enemy_type ==GlobalVariables.EnemyType.Enemy_type3:
					enemy_instance= flying_enemy_3.instance()
				if spawn_position == GlobalVariables.SpawnPosition.Above:
					enemy_instance.set_spawn_position(GlobalVariables.SpawnPosition.Above)
					enemy_instance.position = Vector2(get_node("Camera2D/SpawnPointsRoot/SpawnPointAbovePlayer").get_global_position().x, -144)
				elif spawn_position == GlobalVariables.SpawnPosition.BehindDown:
					enemy_instance.position = Vector2(get_node("Camera2D/SpawnPointsRoot/SpawnPointBehindDownPlayer").get_global_position().x, 261)
				elif spawn_position == GlobalVariables.SpawnPosition.BehindUp:
					enemy_instance.set_spawn_position(GlobalVariables.SpawnPosition.BehindUp)
					enemy_instance.position = Vector2(get_node("Camera2D/SpawnPointsRoot/SpawnPointBehindPlayer").get_global_position().x, -144)
				if i == (number_of_enemies-1) and enemy_type !=GlobalVariables.EnemyType.Enemy_back:
					enemy_instance.piking()
				get_parent().add_child(enemy_instance)
				enemy_instance.add_to_group("enemies")
				yield(get_tree().create_timer(delay_between_spawns), "timeout")
	var enemies = get_tree().get_nodes_in_group("enemies")
	get_tree().call_group("enemies", "end_wave")
func create_warning(var caution_direction, var time):
	interface.launch_warning(caution_direction, time)

func _playAudio(var patch):
	var music_file = patch
	var stream = AudioStream.new()
	var music_player =  get_node("AudioStream")
	var music = load(music_file)
	music_player.stream = music
	music_player.play()
