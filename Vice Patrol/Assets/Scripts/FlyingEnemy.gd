extends KinematicBody2D
var velocity = Vector2()
export (float) var duration_time = 15
var wave_ended = false
var piking = false
var this_enemy_start_position
func set_spawn_position(var position):
	GlobalVariables.enemy_spawn_position = position
	this_enemy_start_position = position
func _process(delta):
	if !wave_ended and !GlobalVariables.is_player_respawning:
		velocity.x = GlobalVariables.playerVelocity_x
		velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))
	elif GlobalVariables.is_player_respawning:
		queue_free()
#		if this_enemy_start_position == GlobalVariables.SpawnPosition.BehindUp:
#			position.x = GlobalVariables.respawn_position.x-100
#		else:
#			position.x = GlobalVariables.respawn_position.x+350
	if piking and wave_ended:
		velocity.x = GlobalVariables.playerVelocity_x + randi()%50-50
		velocity = move_and_slide(velocity, Vector2(0, -1),5,4,rad2deg(75))
	
	
func piking():
	piking = true
func end_wave():
	if !piking:
		yield(get_tree().create_timer(duration_time), "timeout")
		wave_ended = true
		velocity.x -=200
		yield(get_tree().create_timer(5), "timeout")
		queue_free()
	if piking:
		yield(get_tree().create_timer(duration_time), "timeout")
		velocity.y +=200
		wave_ended = true
		yield(get_tree().create_timer(5), "timeout")
		queue_free()
	