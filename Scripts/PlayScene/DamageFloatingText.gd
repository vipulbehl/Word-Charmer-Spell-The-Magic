extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#rect_position.x = get_parent().rect_position.x + (get_parent().rect_size.x/2) 
	#rect_position.y = get_parent().rect_position.y + (get_parent().rect_size.y/2)


func show_value(value, type):
	var interpolate = false
	var travel = Vector2(0, -80)
	var duration = 3
	if type=="coin":
		duration = 1
	if type=="":
		duration = 1
	var spread = PI/2 
	text = str(value)
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	rect_pivot_offset = rect_size / 2
	$Tween.interpolate_property(self, "rect_position",rect_position, rect_position + movement,duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",1.0, 0.0, duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	if type == "damage":
		modulate = Color(1, 0, 0)
		interpolate = true
	elif type == "heal":
		modulate = Color(0.07,0.67,0.36)
		interpolate = true
	elif type == "frozen":
		modulate = Color(0.13,0.46,0.76)
	elif type == "bleed":
		modulate = Color(0.58,0.09,0.09)
	elif type == "dodge":
		modulate = Color(0.07,0.67,0.36)
	elif type == "coin":
		modulate = Color(0.85,0.79,0.09)
		find_node("coin_image").visible = true
	elif type == "paralyze":
		modulate = Color(0.85,0.79,0.09)
	elif type == "burn":
		modulate = Color(0.79,0.18,0.31)
	elif type == "dodge":
		modulate = Color(0.21,0.72,0.26)
	
	if interpolate:
		$Tween.interpolate_property(self, "rect_scale",rect_scale*2, rect_scale,0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_parent().queue_free()
	#queue_free()
