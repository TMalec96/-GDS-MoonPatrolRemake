extends Control

var time = 0
var time_mult = 1
var paused = false

onready var timer = get_node("MainArea/ExtraArea/TimeValue")
onready var lifesLabel = get_node("MainArea/LifesNumber")
onready var scoreLabel = get_node("MainArea/CurrentScoreValue")
onready var hiScoreLabel = get_node("MainArea/HiScore")
onready var controlPointLabel1 = get_node("MainArea/ExtraArea/ControlPointValue")
onready var controlPointLabel2 = get_node("MainArea/ExtraArea/ControlPointValue2")

func _ready():
	set_process(true)

func _process(delta):
	if not paused:
		time += delta * time_mult
		timer.set_text(String(int(time)))
	lifesLabel.set_text(String(GlobalVariables.playerLifes))
	scoreLabel.set_text(String(GlobalVariables.playerScore))
	if GlobalVariables.playerScore >= GlobalVariables.hiScore:
			GlobalVariables.hiScore = GlobalVariables.playerScore
			hiScoreLabel.set_text(String(GlobalVariables.hiScore))
	controlPointLabel1.set_text(String(GlobalVariables.currentCheckpoint))
	controlPointLabel2.set_text(String(GlobalVariables.currentCheckpoint))