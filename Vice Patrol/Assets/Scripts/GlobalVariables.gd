extends Node

var playerLifes = 0
var playerScore = 0
var gameTime = 0
var hiScore = 0
var is_player_respawning = false
var playerVelocity_x = 0
var currentCheckpoint = ""
enum EnemyType {Enemy_type1,Enemy_type2,Enemy_type3,Enemy_back}
enum SpawnPosition {Above,BehindUp,BehindDown}
