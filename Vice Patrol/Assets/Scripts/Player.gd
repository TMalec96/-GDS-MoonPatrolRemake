extends KinematicBody2D
#PLAYER MOVEMENT
onready var ground_ray1 = get_node("groundray1")
onready var ground_ray2 = get_node("groundray2")
export (int) var min_player_speed = 200 #Player speed
export (int) var avg_player_speed = 300
export (int) var max_player_speed = 400
export (int) var jump_speed = 600
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false
#CAMERA MOVEMENT
onready var camera = get_node("Camera2D")
export(float) var camera_offset_drag_right = 150
export(float) var camera_offset_drag_left = 400
export(float) var camera_offset_drag_speed = 2
export(float) var camera_offset_back_drag = .02
#PLAYER START
export (int) var start_delay = 4

#BACK ATTACKING ENEMY
var back_enemy = preload("res://Scenes/BackAttack_Enemy.tscn")

#PLAYER SHOOTING
var bullet1 = preload("res://Scenes/BulletFront.tscn")
var bullet2 = preload("res://Scenes/BulletUp.tscn")
var can_fire =true
var rate_of_fire = 0.4

#PLAYER SCORING
onready var enemy_detector_ray = get_node("EnemyDetector")

#PLAYER LIFES
export (int) var lifes = 3
export (float) var respawn_delay = 2.0
export (int) var reversing_distance = 500
var is_dead = false
var is_respawning = false

#FLYING ENEMIES
var flying_enemy_1 = preload("res://Scenes/Flying_Enemy_1.tscn")
var flying_enemy_2 = preload("res://Scenes/Flying_Enemy_2.tscn")
var flying_enemy_3 = preload("res://Scenes/Flying_Enemy_3.tscn")

func _ready():
	GlobalVariables.playerLifes = lifes
func _respawn():
	self.hide()
	velocity.x=0
	velocity.y=0
	position.x -= reversing_distance
	yield(get_tree().create_timer(respawn_delay),"timeout")
	self.show()
	GlobalVariables.playerLifes -= 1
	is_respawning = false
func _process(delta):
	if !is_respawning:
		FireLoop()
	else:
		yield(get_tree().create_timer(start_delay), "timeout")		
func get_input():
	
	if !is_respawning:
		velocity.x = avg_player_speed
		var right_pressed = Input.is_action_pressed('ui_right')
		var right_released = Input.is_action_just_released('ui_right')
		var left_released = Input.is_action_just_released('ui_left')
		var left_pressed = Input.is_action_pressed('ui_left')
		var jump = Input.is_action_just_pressed('ui_up')
		if jump and (ground_ray1.is_colliding() or ground_ray2.is_colliding()):
			jumping = true
			velocity.y = -jump_speed
			_set_wheels_position_global()
			yield(get_tree().create_timer(1), "timeout")
			jumping = false	
		if right_pressed:
			velocity.x = max_player_speed
			if camera.offset.x>=camera_offset_drag_right:
				camera.offset.x -= camera_offset_drag_speed
		if left_pressed:
			velocity.x = min_player_speed
			if camera.offset.x <= camera_offset_drag_left:
				camera.offset.x += camera_offset_drag_speed
		if left_released:
			velocity.x = avg_player_speed
			while(camera.offset.x >= 300):
				camera.offset.x -= camera_offset_drag_speed
				yield(get_tree().create_timer(camera_offset_back_drag), "timeout")
		if right_released:
			velocity.x = avg_player_speed
			while(camera.offset.x <= 300):
				camera.offset.x += camera_offset_drag_speed
				yield(get_tree().create_timer(camera_offset_back_drag), "timeout")
func _physics_process(delta):
	_process_score()
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
func FireLoop():
	if Input.is_action_pressed("Shoot") and can_fire:
		can_fire = false
#		get_node("TurnAxis").rotation = get_angle_to(get_global_transform())
		var bullet_instanceFront = bullet1.instance()
		var bullet_instanceUp = bullet2.instance()
		bullet_instanceFront.position = get_node("TurnAxis/CastPoint1").get_global_position()
		bullet_instanceUp.position = get_node("TurnAxis/CastPoint2").get_global_position()
		bullet_instanceUp.Initialize(velocity.x)
#		bullet_instance.rotation = get_global_rotation()
		get_parent().add_child(bullet_instanceFront)
		get_parent().add_child(bullet_instanceUp)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true
func dead():
	is_dead = true
	queue_free()
	SceneLoader.goto_scene("res://Scenes/GameOverScene.tscn")
#OPTYMALIZACJA FUNKCJI
func process_damage(var collision):
		if "Enemy" in collision.collider.name:
			is_respawning = true
			if GlobalVariables.playerLifes >= 1:
				collision.collider.dead()
				_respawn()
			elif GlobalVariables.playerLifes<= 0:
				collision.collider.dead()
				dead()
func process_damage_enemy():
	is_respawning = true
	if GlobalVariables.playerLifes >= 1:
		_respawn()
	elif GlobalVariables.playerLifes <= 0:
		dead()
func spawn_enemies(var spawn_position, var enemy_type, var number_of_enemies, var delay_between_spawns):
	for i in range(number_of_enemies):
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
			enemy_instance.position = get_node("SpawnPointsRoot/SpawnPointAbovePlayer").get_global_position()
		elif spawn_position == GlobalVariables.SpawnPosition.BehindDown:
			enemy_instance.position = get_node("SpawnPointsRoot/SpawnPointBehindDownPlayer").get_global_position()
		elif spawn_position == GlobalVariables.SpawnPosition.Behind:
			enemy_instance.position = get_node("SpawnPointsRoot/SpawnPointBehindPlayer").get_global_position()
		print("dupa")
		get_parent().add_child(enemy_instance)
		yield(get_tree().create_timer(delay_between_spawns), "timeout")

