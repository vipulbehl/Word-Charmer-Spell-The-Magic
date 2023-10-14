extends Node2D

var share
var LINK = "https://play.google.com/store/apps/details?id=com.bluemoongames.wordcharmer"
var promotionText = "I invite you to download this awesome game that I found"
var homeSceneRef

func _ready():
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")
	else:
		print("Unable to get share singleton")
	
	homeSceneRef = get_parent()

func _on_CancelButton_button_up():
	find_node("Control").visible = false
	find_node("BackgroundTint").visible = false


func _on_ShareButton_button_up():
	homeSceneRef.play_button_click_sound()
	if not SavedGames.saveGameDict["shared"]:
		SavedGames.saveGameDict["coins"] += 5000
		SavedGames.saveGameDict["shared"] = true
		SavedGames.save_game_state()
	
	if share != null:
		share.shareText("Share Word Charmer", promotionText, LINK)
	find_node("Control").visible = false
	find_node("BackgroundTint").visible = false

func show_share_dialog():
	find_node("Control").visible = true
	find_node("BackgroundTint").visible = true


func _on_FacebookShare_button_up():
	homeSceneRef.play_button_click_sound()
	if not SavedGames.saveGameDict["facebookShared"]:
		SavedGames.saveGameDict["coins"] += 5000
		SavedGames.saveGameDict["facebookShared"] = true
		SavedGames.save_game_state()
	OS.shell_open("https://www.facebook.com/sharer/sharer.php?u="+LINK)
	find_node("Control").visible = false
	find_node("BackgroundTint").visible = false


func _on_TwitterShare_button_up():
	homeSceneRef.play_button_click_sound()
	if not SavedGames.saveGameDict["twitterShared"]:
		SavedGames.saveGameDict["coins"] += 5000
		SavedGames.saveGameDict["twitterShared"] = true
		SavedGames.save_game_state()
	OS.shell_open("http://www.twitter.com/intent/tweet?url=%s&text=%s"%[LINK,promotionText])
	find_node("Control").visible = false
	find_node("BackgroundTint").visible = false
