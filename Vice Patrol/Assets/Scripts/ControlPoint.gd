extends Label
export (bool) var is_endpoint = false 
onready var ray = get_node("RayCast2D") 
func _process(delta):
	if ray.is_colliding():
		GlobalVariables.currentCheckpoint = get_text()
		if is_endpoint:
			SceneLoader.goto_scene("res://Scenes/SumScreen.tscn")
			

