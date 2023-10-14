extends GridContainer

signal validate_word


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	var childCount = self.get_child_count()
	if childCount <= 5:
		_set_selected_button_size(60)
	elif childCount <=7:
		_set_selected_button_size(55)
	elif childCount <=10:
		_set_selected_button_size(45)
	elif childCount <=12:
		_set_selected_button_size(40)
	else:
		_set_selected_button_size(30)

func _getSelectedLetters(): 
	var selectedLetters = ''
	for k in self.get_children():
		var label : Label = k.get_node("SelectedButtonLabel")
		selectedLetters += label.text
	return selectedLetters

func _emitValidateWordSignal():
	emit_signal("validate_word")


func _set_selected_button_size(min_size):
	for child in self.get_children():
		child.find_node("SelectedButtonTextureButton").rect_min_size.x = min_size
		child.find_node("SelectedButtonTextureButton").rect_min_size.y = min_size
