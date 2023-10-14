extends Node2D

var toggleMenu = false

func _ready():
	pass # Replace with function body.


func _on_LoadGameButton_button_up():
	GooglePlay.load_saved_games()
	toggle_menu()
	yield(get_tree().create_timer(1), "timeout")
	Global.goto_scene("res://Scenes/HomeScene/HomeScene.tscn", get_parent())


func _on_NewGameButton_button_up():
	toggle_menu()



func toggle_menu():
	toggleMenu = not toggleMenu
	find_node("LoadPreviousGame").visible = toggleMenu
	find_node("BackgroundTint").visible = toggleMenu


func _on_LoadGameTexture_button_up():
	_on_LoadGameButton_button_up()


func _on_NewGameTexture_button_up():
	toggle_menu()
