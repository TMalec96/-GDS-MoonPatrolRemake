extends Node
var god_mode = false
var time = 0
var respawn_position = Vector2(0,0)
var respawn_position_for_enemies_back
var respawn_position_for_enemies_above
var enemy_spawn_position
var _last_spawned_index = 0
var progresBarvalue = 0
var playerReversingDistance = 0
var paused = true
var bomber_shoot_interval = 0
var playerLifes = 0
var playerScore = 0
var gameTime = 0
var hiScore = 0
var time_mult = 1
var is_player_respawning = false
var playerVelocity_x = 0
var currentCheckpoint = ""
enum EnemyType {Enemy_type1,Enemy_type2,Enemy_type3,Enemy_back}
enum SpawnPosition {Above,BehindUp,BehindDown}
enum CautionDirection {UP,MID,DOWN}
func _process(delta):
	if not paused:
		GlobalVariables.time += delta * time_mult
