extends RayCast2D
var was_spawned = false
export (GlobalVariables.SpawnPosition) var spawn_position  = GlobalVariables.SpawnPosition.Above
export (GlobalVariables.EnemyType) var enemy_type = GlobalVariables.EnemyType.Enemy_type1
export (int) var time_delay = 2
export (int) var number_of_enemies = 3
export (float) var delay_between_spawns = 1
func _process(delta):
	if is_colliding() and !was_spawned:
#		yield(get_tree().create_timer(time_delay), "timeout")
		get_collider().spawn_enemies(spawn_position,enemy_type,number_of_enemies,delay_between_spawns)
		was_spawned = true
