extends Control

var sceneRoot
var playScene

var endlessModeImage = preload("res://Resources/UI Elements/Buttons/BeforeClick/locked_grey.png")
var musicEnabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/music_on_yellow.png")
var musicEnabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/music_on_yellow.png")
var musicDisabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/music_off_yellow.png")
var musicDisabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/music_off_yellow.png")
var soundEnabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/sound_on_yellow.png")
var soundEnabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/sound_on_yellow.png")
var soundDisabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/sound_off_yellow.png")
var soundDisabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/sound_off_yellow.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	sceneRoot = get_parent().get_parent()
	playScene = sceneRoot.get_parent()

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

func pause_game():
	self.visible = true
	sceneRoot.find_node("BackgroundTint").visible = true
	#get_tree().paused = true


func _on_Resume_button_up():
	playScene.play_button_click_sound()
	unpause()

func _on_Home_button_up():
	playScene.play_button_click_sound()
	unpause()
	if not Global.isEndlessMode:
		Global.isLevelScene = true
	Global.goto_scene("res://Scenes/HomeScene/HomeScene.tscn", sceneRoot.get_parent())


func unpause():
	self.visible = false
	sceneRoot.find_node("BackgroundTint").visible = false
	#get_tree().paused = false


func _on_RestartLevel_button_up():
	playScene.play_button_click_sound()
	unpause()
	Global.goto_scene("res://Scenes/Play/IntermediateScene.tscn", sceneRoot.get_parent())


func _on_SoundButton_button_up():
	playScene.play_button_click_sound()
	SavedGames.saveGameDict["soundEnabled"] = not SavedGames.saveGameDict["soundEnabled"] 
	SavedGames.save_game_state()


func _on_MusicButton_button_up():
	playScene.play_button_click_sound()
	SavedGames.saveGameDict["musicEnabled"] = not SavedGames.saveGameDict["musicEnabled"] 
	SavedGames.save_game_state()
	playScene.play_background_sound()


func _on_play_green_button_up():
	_on_Resume_button_up()


func _on_replay_green_button_up():
	_on_RestartLevel_button_up()


func _on_menu_green_button_up():
	_on_Home_button_up()
