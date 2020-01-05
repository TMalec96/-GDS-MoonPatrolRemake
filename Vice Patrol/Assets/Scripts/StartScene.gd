extends CanvasLayer
var animating = false
var godeMode = 0
export (bool) var title_screen = false
func _ready():
	if title_screen:
		_animate_title()
	if !title_screen:
		$Control/Score.text =  String(GlobalVariables.playerScore)
func _process(delta):
	if !animating:
		_animate()
	_get_input()
	get_godMode_command()
func _animate():
	animating = true
	for i in range(100):
		var index = i*0.01
		$Control/StartGame.modulate.a = index
		yield(get_tree().create_timer(0.0001), "timeout")
	for i in range(100):
		var index = 1 - i*0.01
		$Control/StartGame.modulate.a = index
		yield(get_tree().create_timer(0.0001), "timeout")
	animating = false
func _animate_title():
	for i in range(100):
		var index = i*0.01
		$Control/Title.modulate.a = index
		yield(get_tree().create_timer(0.001), "timeout")
func _get_input():
	var enter = Input.is_action_just_released('ui_accept')
	var exit = Input.is_action_just_released('ui_exit')
	if enter:
		SceneLoader.goto_scene("res://Scenes/World.tscn")
	if exit:
		get_tree().quit()

func get_godMode_command():
	var up = Input.is_action_just_released('ui_up')
	if up:
		godeMode+=1
	if godeMode == 3:
		$Control/Title.modulate = Color("ff0000")
		GlobalVariables.god_mode = true