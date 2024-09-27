extends "res://Assets/Scripts/Interface.gd"
export (int) var bonus_points = 1000 
export (int) var average_time = 5
export (int) var top_record = 5
onready var you_broken_record = get_node("ColorRect/YouBrokenRecord")
var time_to_reach_string  ="TIME TO REACH POINT ' "
var your_time_string  = "YOUR TIME : "
var the_average_time_string  = "THE AVERAGE TIME : "
var top_record_string = "TOP RECORD : "
var good_bonus_points_string = "GOOD BONUS POINTS : "
func _ready():
	GlobalVariables.paused = true
	progresBar.value = GlobalVariables.progresBarvalue + 4
	controlPointLabel1.set_text(String(GlobalVariables.currentCheckpoint))
	controlPointLabel2.set_text(String(GlobalVariables.currentCheckpoint))
	_animate_given_string(time_to_reach_string + String(GlobalVariables.currentCheckpoint)+" '",$ColorRect/TimeToReach)
	yield(get_tree().create_timer(0.5),"timeout")
	_animate_given_string(your_time_string + String(int(GlobalVariables.time)) ,$ColorRect/YourTime)
	yield(get_tree().create_timer(0.5),"timeout")
	_animate_given_string(the_average_time_string +String(average_time),$ColorRect/AverageTime)
	yield(get_tree().create_timer(0.5),"timeout")
	_animate_given_string(top_record_string + String(top_record),$ColorRect/TopRecord)
	yield(get_tree().create_timer(0.5),"timeout")
	_animate_given_string(good_bonus_points_string + String(bonus_points) ,$ColorRect/GoodBonusPoints)
	yield(get_tree().create_timer(3),"timeout")
	_count_extra_points($ColorRect/GoodBonusPoints)
	yield(get_tree().create_timer(2),"timeout")
	if GlobalVariables.time < top_record:
		you_broken_record.visible = true
	yield(get_tree().create_timer(2),"timeout")
	GlobalVariables.playerScore +=bonus_points
	_change_scene()
func _count_extra_points(var target_string):
	var clear_string = good_bonus_points_string
	if (int(average_time) - int(GlobalVariables.time) > 0):
		bonus_points += (int(average_time) - int(GlobalVariables.time))*100
		target_string.text = clear_string +String(bonus_points)
		yield(get_tree().create_timer(0.5),"timeout")
func _change_scene():
	
	if GlobalVariables.currentCheckpoint.begins_with("E"):
		SceneLoader.goto_scene("res://Scenes/World2.tscn")
	if GlobalVariables.currentCheckpoint.begins_with("J"):
		SceneLoader.goto_scene("res://Scenes/GameOverScene.tscn")
func _animate_given_string(var string_to_animate,var element_to_animate):
	var string = ""
	for c in string_to_animate:
		string += c
		element_to_animate.text = string
		yield(get_tree().create_timer(0.1),"timeout")
	