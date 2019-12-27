extends Node
var time = 0
var progresBarvalue = 0
var playerReversingDistance = 0
var paused = true
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
func _process(delta):
	if not paused:
		GlobalVariables.time += delta * time_mult
