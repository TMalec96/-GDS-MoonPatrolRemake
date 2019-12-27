extends Path2D

onready var follow = get_node("PathFollow2D")
var path_other = preload("res://Curves/Flying_Enemy_Above_Income.tres")
func _ready():
	set_process(true)
func _process(delta):
		follow.set_offset(follow.get_offset() + 350 *delta)
#		if(follow.offset>1730):
#			print("kaszanka")
#			curve = path_other
#			follow.loop = true
		
	#spaw CURVE 2D Resource


