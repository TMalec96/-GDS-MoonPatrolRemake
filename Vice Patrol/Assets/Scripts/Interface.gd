extends Control
onready var timer = get_node("MainArea/ExtraArea/TimeValue")
onready var lifesLabel = get_node("MainArea/LifesArea/LifesNumber")
onready var scoreLabel = get_node("MainArea/ScoreArea/CurrentScoreValue")
onready var hiScoreLabel = get_node("MainArea/ScoreArea/HiScore")
onready var controlPointLabel1 = get_node("MainArea/ExtraArea/ControlPointValue")
onready var controlPointLabel2 = get_node("MainArea/ExtraArea/ControlPointValue2")
onready var progresBar = get_node("MainArea/ProgressBar")
onready var cautionUp = get_node("MainArea/ExtraArea/CautionUpText")
onready var cautionMid = get_node("MainArea/ExtraArea/CautionMidText")
onready var cautionDown = get_node("MainArea/ExtraArea/CautionDownText")
onready var cautionText = get_node("MainArea/ExtraArea/CautionText_")
var last_control_point  = GlobalVariables.currentCheckpoint
var active_caution_direction = null
export(bool)var is_end_screen = false
func _ready():
	if !is_end_screen:
		GlobalVariables.time = 0 
		hiScoreLabel.set_text(String(GlobalVariables.hiScore))
		progresBar.value = GlobalVariables.progresBarvalue
		set_process(true)
	else:
		$MainArea/LifesArea/LifeIcon.visible = false
		$MainArea/LifesArea/LifesNumber.visible = false
		_changeControlPoint()

func _process(delta):
	timer.set_text(String(int(GlobalVariables.time)))
	lifesLabel.set_text(String(GlobalVariables.playerLifes))
	scoreLabel.set_text(String(GlobalVariables.playerScore))
	if GlobalVariables.playerScore >= GlobalVariables.hiScore:
			GlobalVariables.hiScore = GlobalVariables.playerScore
			hiScoreLabel.set_text(String(GlobalVariables.hiScore))
	_changeControlPoint()
	if GlobalVariables.playerLifes == 0:
		$MainArea/LifesArea/LifeIcon.visible = false
		$MainArea/LifesArea/LifesNumber.visible = false
		GlobalVariables.playerLifes -= 1
		_playAudio("res://Assets/Music/game_over2.wav")
		var index = 0 
		while(index <3):
			$GameOverSprite.visible = true
			yield(get_tree().create_timer(1), "timeout")
			$GameOverSprite.visible = false
			index+=1
	
func _changeControlPoint():
	if last_control_point != GlobalVariables.currentCheckpoint:
		GlobalVariables.progresBarvalue += 4
		_playAudio("res://Assets/Music/level_complete_or_period.wav") #dzwiek zmiany checkpointa
		progresBar.value = GlobalVariables.progresBarvalue
		last_control_point = GlobalVariables.currentCheckpoint
		controlPointLabel1.set_text(String(last_control_point))
		controlPointLabel2.set_text(String(last_control_point))
	if  is_end_screen:
		progresBar.value = GlobalVariables.progresBarvalue
		last_control_point = GlobalVariables.currentCheckpoint
		controlPointLabel1.set_text(String(last_control_point))
		controlPointLabel2.set_text(String(last_control_point))
func launch_warning(var caution_direction, var time):
	if caution_direction == GlobalVariables.CautionDirection.UP:
		active_caution_direction = cautionUp
	elif caution_direction == GlobalVariables.CautionDirection.MID:
		active_caution_direction = cautionMid
	else:
		active_caution_direction = cautionDown
	_warning_animation(time)
func _warning_animation(var time):
	var index = 0 
	var switch_time = time/3
	while(index <3):
		active_caution_direction.modulate = Color("ff4ba0")
		cautionText.visible = true
		yield(get_tree().create_timer(switch_time), "timeout")
		active_caution_direction.modulate = Color("ffffff")
		cautionText.visible = false
		yield(get_tree().create_timer(switch_time), "timeout")
		index += 1
func _playAudio(var patch):
	var music_file = patch
	var stream = AudioStream.new()
	var music_player =  get_node("AudioStream")
	var music = load(music_file)
	music_player.stream = music
	music_player.play()