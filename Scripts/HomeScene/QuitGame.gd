extends Node2D

var toggleMenu = false

func _ready():
	pass
	

func toggle_menu():
	toggleMenu = not toggleMenu
	find_node("QuitGame").visible = toggleMenu
	find_node("BackgroundTint").visible = toggleMenu


func _on_QuitButton_button_up():
	get_tree().quit()


func _on_CancelButton_button_up():
	toggle_menu()
