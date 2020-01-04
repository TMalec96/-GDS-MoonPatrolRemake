extends CanvasLayer

func _on_StartGameButton_pressed():
	SceneLoader.goto_scene("res://Scenes/World.tscn")


func _on_ExitGameButton_pressed():
	get_tree().quit()





func _on_MainMenuButton_pressed():
	SceneLoader.goto_scene("res://Scenes/StartScene.tscn")
