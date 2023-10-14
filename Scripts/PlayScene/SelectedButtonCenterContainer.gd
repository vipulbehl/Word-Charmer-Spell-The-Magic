extends CenterContainer

var pos = 1 setget setPos, getPos

func setPos(new_value):
	pos = new_value

func getPos() -> int:
	return pos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func animate_buttons(animation_flag):
	if animation_flag:
		find_node("SelectionAnimation").play("selected_animation")
	else:
		find_node("SelectionAnimation").stop()
