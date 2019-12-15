extends Control

var time = 0
var time_mult = 1
var paused = false

onready var timer = get_node("MainArea/ExtraArea/TimeValue")
onready var lifesLabel = get_node("MainArea/LifesNumber")
onready var scoreLabel = get_node("MainArea/CurrentScoreValue")

func _ready():
	set_process(true)

func _process(delta):
	if not paused:
		time += delta * time_mult
		timer.set_text(String(int(time)))
	lifesLabel.set_text(String(GlobalVariables.playerLifes))
	scoreLabel.set_text(String(GlobalVariables.playerScore))
	
	