extends Position2D

onready var RespawnRay = get_node("ReSpawnRay")
func _ready():
	pass # Replace with function body.
func _process(delta):
	if RespawnRay.is_colliding():
		GlobalVariables.respawn_position = position