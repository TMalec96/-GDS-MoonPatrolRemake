extends "res://Assets/Scripts/Interface.gd"
export (int) var bonus_points = 1000 
export (int) var average_time = 80
export (int) var top_record = 80
onready var timer_1 = get_node("ColorRect/TimeValue2")
onready var control_point = get_node("ColorRect/ControlPointValue3")
onready var good_bonus_points = get_node("ColorRect/GoodBonusPointsValue")
onready var you_broken_record = get_node("ColorRect/YouBrokenRecord")
onready var average_time_value = get_node("ColorRect/AverageTimeValue")
onready var top_record_value = get_node("ColorRect/TopRecordValue")

func _ready():
	GlobalVariables.paused = true
	progresBar.value = GlobalVariables.progresBarvalue + 4
	controlPointLabel1.set_text(String(GlobalVariables.currentCheckpoint))
	controlPointLabel2.set_text(String(GlobalVariables.currentCheckpoint))
	average_time_value.set_text(String(average_time))
	top_record_value.set_text(String(top_record))
	timer_1.set_text(String(int(GlobalVariables.time)))
	control_point.set_text(String(GlobalVariables.currentCheckpoint))
	good_bonus_points.set_text(String(bonus_points))
	_count_extra_points()
	yield(get_tree().create_timer(2),"timeout")
	good_bonus_points.set_text(String(int(bonus_points)))
	if GlobalVariables.time < top_record:
		you_broken_record.visible = true
		
	
func _count_extra_points():
	if (int(average_time) - int(GlobalVariables.time) > 0):
		bonus_points += (int(average_time) - int(GlobalVariables.time))*100
func _change_scene():
	if GlobalVariables.currentCheckpoint =="E":
		SceneLoader.goto_scene("res://Scenes/World2.tscn")
	if GlobalVariables.currentCheckpoint =="J":
		SceneLoader.goto_scene("res://Scenes/GameOverScene.tscn")