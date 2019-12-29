extends StaticBody2D

export (int) var scoreValue = 100
export (bool) var is_destroyable = false
var is_dead = false
var is_jumped = false
func dead():
	if is_destroyable:
		is_dead = true
		GlobalVariables.playerScore += scoreValue
		queue_free()

func countScore():
	if !is_jumped:
		GlobalVariables.playerScore += scoreValue
		is_jumped = true
func hide():
	$Sprite.visible = false
	set_collision_mask_bit(1,false)
func show():
	$Sprite.visible = true
	set_collision_mask_bit(1,true)
