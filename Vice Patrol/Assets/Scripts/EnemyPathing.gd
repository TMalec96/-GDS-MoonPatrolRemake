extends Path2D

onready var follow = get_node("PathFollow2D")
var path_2= preload("res://Curves/Infinity_Curve2.tres")
var path_1 = preload("res://Curves/Infinity_Curve.tres")
var path_3= preload("res://Curves/Infinity_Curve3.tres")
var path_4= preload("res://Curves/Infinity_Curve4.tres")
func _ready():
	var path_array  = [path_1,path_2,path_3,path_4]
	set_process(true)
	var index = 0
	while(GlobalVariables._last_spawned_index == index):
		index = randi()%4
	GlobalVariables._last_spawned_index  = index
	curve = path_array[index]
	print("index: " + String(index))
	follow.loop = true
func _process(delta):
	follow.set_offset(follow.get_offset() + 200 *delta)
	

	#spaw CURVE 2D Resource


