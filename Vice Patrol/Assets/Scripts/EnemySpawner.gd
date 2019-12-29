extends RayCast2D
var was_spawned = false
export (GlobalVariables.SpawnPosition) var spawn_position  = GlobalVariables.SpawnPosition.Above
export (GlobalVariables.EnemyType) var enemy_type = GlobalVariables.EnemyType.Enemy_type1
export (GlobalVariables.CautionDirection) var caution_direction = GlobalVariables.CautionDirection.UP
export (int) var time_delay = 3
export (int) var number_of_enemies = 3
export (float) var delay_between_spawns = 1
func _process(delta):
	if is_colliding() and !was_spawned:
		get_collider().spawn_enemies(spawn_position,enemy_type,number_of_enemies,delay_between_spawns,time_delay,caution_direction)
		was_spawned = true
