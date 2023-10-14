extends Node2D

var show = false
var homeSceneRef

var musicEnabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/music_on_yellow.png")
var musicEnabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/music_on_yellow.png")
var musicDisabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/music_off_yellow.png")
var musicDisabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/music_off_yellow.png")
var soundEnabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/sound_on_yellow.png")
var soundEnabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/sound_on_yellow.png")
var soundDisabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/sound_off_yellow.png")
var soundDisabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/sound_off_yellow.png")



func _ready():
	homeSceneRef = get_parent()

func _process(_delta):
	if SavedGames.saveGameDict["musicEnabled"]:
		find_node("MusicButton").texture_normal = musicEnabledNormal
		find_node("MusicButton").texture_pressed = musicEnabledPressed
	else:
		find_node("MusicButton").texture_normal = musicDisabledNormal
		find_node("MusicButton").texture_pressed = musicDisabledPressed
	
	if SavedGames.saveGameDict["soundEnabled"]:
		find_node("SoundButton").texture_normal = soundEnabledNormal
		find_node("SoundButton").texture_pressed = soundEnabledPressed
	else:
		find_node("SoundButton").texture_normal = soundDisabledNormal
		find_node("SoundButton").texture_pressed = soundDisabledPressed


func toggle():
	show = not show
	find_node("Settings").visible = show
	find_node("ColorRect").visible = show


func _on_close_button_up():
	homeSceneRef.play_button_click_sound()
	toggle()


func _on_MusicButton_button_up():
	homeSceneRef.play_button_click_sound()
	SavedGames.saveGameDict["musicEnabled"] = not SavedGames.saveGameDict["musicEnabled"] 
	SavedGames.save_game_state()
	homeSceneRef.play_background_sound()


func _on_RateButton_button_up():
	homeSceneRef.play_button_click_sound()
	homeSceneRef.rateRef.show_rate_us_dialog()


func _on_ShareButton_button_up():
	homeSceneRef.play_button_click_sound()
	homeSceneRef.shareRef.show_share_dialog()


func _on_SoundButton_button_up():
	homeSceneRef.play_button_click_sound()
	SavedGames.saveGameDict["soundEnabled"] = not SavedGames.saveGameDict["soundEnabled"] 
	SavedGames.save_game_state()
