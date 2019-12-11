extends KinematicBody2D
export (int) var min_player_speed = 200
export (int) var avg_player_speed = 300
export (int) var max_player_speed = 400
export (int) var jump_speed = 600
export (int) var gravity = 1200

export(float) var camera_offset_drag = 100
export(float) var camera_offset_drag_speed = 2
export(float) var camera_offset_back_drag = .02
 
export (int) var start_delay = 4

export (int) var spawn_enemy_distance = 300
export (int) var spawn_enemy_time = 1
export (int) var enemy_boost_time = 2
export (int) var boost_duration_time = 2
export (bool) var spawn_enemy = false
var Enemy = preload("res://Scenes/BackAttack_Enemy.tscn")
var velocity = Vector2()
var jumping = false

onready var camera = get_node("Camera2D")

onready var ground_ray1 = get_node("groundray1")
onready var ground_ray2 = get_node("groundray2")
var bullet1 = preload("res://Scenes/BulletFront.tscn")
var bullet2 = preload("res://Scenes/BulletUp.tscn")
var can_fire =true
var rate_of_fire = 0.4

export (int) var lifes = 3
export (float) var respawn_delay = 2.0
export (int) var reversing_distance = 500
var is_dead = false
var is_respawning = false

func _ready():
	if spawn_enemy:
		spawn_enemy_afer_time(spawn_enemy_time)

func _respawn(var delay):
	self.hide()
	velocity.x=0
	velocity.y=0
	position.x -= reversing_distance
	yield(get_tree().create_timer(respawn_delay),"timeout")
	self.show()
	lifes -= 1
	is_respawning = false

func _process(delta):
	if !is_respawning:
		FireLoop()
	else:
		yield(get_tree().create_timer(start_delay), "timeout")
		
func _process_movement(var speed_increment,var old_speed,var new_speed):
	var incrementation = new_speed/ speed_increment
	for i in range(speed_increment):
		old_speed += incrementation
	return old_speed
		
		
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
		if right_pressed:
			velocity.x = max_player_speed
			if !camera.offset.x<=-camera_offset_drag:
				camera.offset.x -= camera_offset_drag_speed
		if left_pressed:
			velocity.x = min_player_speed
			if camera.offset.x <= camera_offset_drag:
				camera.offset.x += camera_offset_drag_speed
		if left_released:
			velocity.x = avg_player_speed
			while(camera.offset.x >= 0):
				camera.offset.x -= camera_offset_drag_speed
				yield(get_tree().create_timer(camera_offset_back_drag), "timeout")
		if right_released:
			velocity.x = avg_player_speed
			while(camera.offset.x >= 0):
				camera.offset.x <= camera_offset_drag_speed
				yield(get_tree().create_timer(camera_offset_back_drag), "timeout")
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for i in range(get_slide_count() - 1):
	#		ZAMIENIC NA FUNKCJE
		var collision = get_slide_collision(i)
		process_damage(collision)
	_set_wheels_position_x()
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
#		bullet_instance.rotation = get_global_rotation()
		get_parent().add_child(bullet_instanceFront)
		get_parent().add_child(bullet_instanceUp)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true
func dead():
	is_dead = true
	queue_free()
#OPTYMALIZACJA FUNKCJI
func process_damage(var collision):
		if "Enemy" in collision.collider.name:
			is_respawning = true
			if lifes >= 1:
				_respawn(respawn_delay)
			elif lifes <= 0:
				collision.collider.dead()
				dead()
func process_damage_enemy():
	is_respawning = true
	if lifes >= 1:
		self.hide()
		velocity.x=0
		velocity.y=0
		position.x -= reversing_distance
		yield(get_tree().create_timer(respawn_delay),"timeout")
		self.show()
		lifes -= 1
		is_respawning = false
	elif lifes <= 0:
		dead()
func spawn_enemy_afer_time(time):
	var Enemy_instance = Enemy.instance()
	yield(get_tree().create_timer(time), "timeout")
	Enemy_instance.position = Vector2(position.x -spawn_enemy_distance,position.y)
	get_parent().add_child(Enemy_instance)
	Enemy_instance.start_chase(velocity.x,max_player_speed,enemy_boost_time,boost_duration_time)
	


