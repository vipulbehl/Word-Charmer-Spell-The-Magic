extends Node2D

var LINK = "https://play.google.com/store/apps/details?id=com.bluemoongames.wordcharmer"
var homeSceneRef

func _ready():
	homeSceneRef = get_parent()


func _on_RateButton_button_up():
	homeSceneRef.play_button_click_sound()
	OS.shell_open(LINK)
	if not SavedGames.saveGameDict["rated"]:
		SavedGames.saveGameDict["coins"] += 1000
		SavedGames.saveGameDict["rated"] = true
		SavedGames.save_game_state()
	find_node("Control").visible = false
	find_node("BackgroundTint").visible = false


func _on_CancelButton_button_up():
	homeSceneRef.play_button_click_sound()
	find_node("Control").visible = false
	find_node("BackgroundTint").visible = false
	
func show_rate_us_dialog():
	find_node("Control").visible = true
	find_node("BackgroundTint").visible = true
