extends Position2D

onready var RespawnRay = get_node("ReSpawnRay")
var colided = false
func _ready():
	pass # Replace with function body.
func _process(delta):
	if RespawnRay.is_colliding():
		GlobalVariables.respawn_position = position
		colided = true
	if colided:
		queue_free()