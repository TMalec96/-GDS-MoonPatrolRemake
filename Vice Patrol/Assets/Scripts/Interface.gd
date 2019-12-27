extends Control
onready var timer = get_node("MainArea/ExtraArea/TimeValue")
onready var lifesLabel = get_node("MainArea/LifesNumber")
onready var scoreLabel = get_node("MainArea/CurrentScoreValue")
onready var hiScoreLabel = get_node("MainArea/HiScore")
onready var controlPointLabel1 = get_node("MainArea/ExtraArea/ControlPointValue")
onready var controlPointLabel2 = get_node("MainArea/ExtraArea/ControlPointValue2")
onready var progresBar = get_node("MainArea/ProgressBar")
var last_control_point  = GlobalVariables.currentCheckpoint
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