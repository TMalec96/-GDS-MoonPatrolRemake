extends Control
onready var timer = get_node("MainArea/ExtraArea/TimeValue")
onready var lifesLabel = get_node("MainArea/LifesNumber")
onready var scoreLabel = get_node("MainArea/CurrentScoreValue")
onready var hiScoreLabel = get_node("MainArea/HiScore")
onready var controlPointLabel1 = get_node("MainArea/ExtraArea/ControlPointValue")
onready var controlPointLabel2 = get_node("MainArea/ExtraArea/ControlPointValue2")
onready var progresBar = get_node("MainArea/ProgressBar")
onready var cautionUp = get_node("MainArea/ExtraArea/CautionUpText")
onready var cautionMid = get_node("MainArea/ExtraArea/CautionMidText")
onready var cautionDown = get_node("MainArea/ExtraArea/CautionDownText")
onready var cautionText = get_node("MainArea/ExtraArea/CautionText_")
var last_control_point  = GlobalVariables.currentCheckpoint
var active_caution_direction = null
func _ready():
	set_process(true)

func _process(delta):
	timer.set_text(String(int(GlobalVariables.time)))
	lifesLabel.set_text(String(GlobalVariables.playerLifes))
	scoreLabel.set_text(String(GlobalVariables.playerScore))
	if GlobalVariables.playerScore >= GlobalVariables.hiScore:
			GlobalVariables.hiScore = GlobalVariables.playerScore
			hiScoreLabel.set_text(String(GlobalVariables.hiScore))
	_changeControlPoint()
	
func _changeControlPoint():
	if last_control_point != GlobalVariables.currentCheckpoint:
		GlobalVariables.progresBarvalue += 4
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
		active_caution_direction.modulate = Color("ff0000")
		cautionText.visible = true
		yield(get_tree().create_timer(switch_time), "timeout")
		active_caution_direction.modulate = Color("000000")
		cautionText.visible = false
		yield(get_tree().create_timer(switch_time), "timeout")
		index += 1