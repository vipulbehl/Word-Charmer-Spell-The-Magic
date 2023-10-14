extends Node2D

signal get_coins

var show = false

func _ready():
	pass
	
	
func toggle():
	show = not show
	find_node("NoCoins").visible = show
	find_node("ColorRect").visible = show


func _on_CloseButton_button_up():
	toggle()


func _on_GetCoinsButton_button_up():
	toggle()
	emit_signal("get_coins")
