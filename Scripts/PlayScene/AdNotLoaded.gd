extends Node2D

var show = false

func _ready():
	pass # Replace with function body.


func _on_close_button_up():
	toggle()


func toggle():
	show = not show
	find_node("AdNotLoaded").visible = show
	find_node("ColorRect").visible = show
