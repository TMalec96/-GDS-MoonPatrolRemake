extends Path2D

onready var follow = get_node("PathFollow2D")
var path_1 = preload("res://Curves/Above_Curve1.tres")
var path_2= preload("res://Curves/Above_Curve2.tres")
var path_3= preload("res://Curves/Above_Curve3.tres")
var path_4= preload("res://Curves/Behind_Curve1.tres")
var path_5= preload("res://Curves/Behind_Curve2.tres")
var path_6= preload("res://Curves/Behind_Curve3.tres")
var spawn_position = GlobalVariables.SpawnPosition.Above
export (int) var speed_on_path = 300
var path_array
func _ready():
	spawn_position = GlobalVariables.enemy_spawn_position
	if spawn_position == GlobalVariables.SpawnPosition.Above:
		path_array  = [path_1,path_2,path_3]
	else:
		path_array = [path_4,path_5,path_6]
	set_process(true)
	var index = 0
	while(GlobalVariables._last_spawned_index == index):
		index =randi()%path_array.size()
	print(index)
	GlobalVariables._last_spawned_index  = index
	curve = path_array[index]
	follow.loop = true
func _process(delta):
	follow.set_offset(follow.get_offset() + (speed_on_path) *delta)
	

	#spaw CURVE 2D Resource


