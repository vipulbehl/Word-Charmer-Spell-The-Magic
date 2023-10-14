extends Control

# Ad params
onready var admob = $AdMob
var storeGetCoinsAd = false

var levelScene = preload("res://Scenes/Level/Level.tscn")
var storeScene = preload("res://Scenes/Level/Store.tscn")
var settingsScene = preload("res://Scenes/HomeScene/Settings.tscn")
var rateScene = preload("res://Scenes/Level/RateUs.tscn")
var shareScene = preload("res://Scenes/Level/Share.tscn")
var adNotLoadedScene = preload("res://Scenes/Play/AdNotLoaded.tscn")
var quitGameScene = preload("res://Scenes/HomeScene/QuitGame.tscn")
var loadPreviousGameScene = preload("res://Scenes/HomeScene/LoadPreviousGame.tscn")
var dailyCoinsScene = preload("res://Scenes/HomeScene/DailyCoins.tscn")
var levelRef
var settingsRef
var storeRef
var rateRef
var shareRef
var adNotLoadedRef
var quitGameRef
var loadPreviousGameRef
var dailyCoinsRef

var endlessModeImage = preload("res://Resources/UI Elements/Buttons/BeforeClick/locked_grey.png")
var musicEnabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/music_on_yellow.png")
var musicEnabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/music_on_yellow.png")
var musicDisabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/music_off_yellow.png")
var musicDisabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/music_off_yellow.png")
var soundEnabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/sound_on_yellow.png")
var soundEnabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/sound_on_yellow.png")
var soundDisabledNormal = preload("res://Resources/UI Elements/Buttons/BeforeClick/sound_off_yellow.png")
var soundDisabledPressed = preload("res://Resources/UI Elements/Buttons/Clicked/sound_off_yellow.png")

func _ready():
	print("loading level resources")
	Global.set_level_resource_dict()
	print("loading upgrade resources")
	Global.set_upgrade_dict()
	print("loading dictionary resources")
	Global.populate_dictionary()
	
	#admob.load_rewarded_video()
	
	_unlock_endless_mode()
	
	levelRef = levelScene.instance()
	add_child(levelRef)
	
	storeRef = storeScene.instance()
	add_child(storeRef)
	
	rateRef = rateScene.instance()
	add_child(rateRef)
	
	shareRef = shareScene.instance()
	add_child(shareRef)
	
	settingsRef = settingsScene.instance()
	add_child(settingsRef)
	
	adNotLoadedRef = adNotLoadedScene.instance()
	add_child(adNotLoadedRef)
	
	quitGameRef = quitGameScene.instance()
	add_child(quitGameRef)
	
	loadPreviousGameRef = loadPreviousGameScene.instance()
	add_child(loadPreviousGameRef)
	
	dailyCoinsRef = dailyCoinsScene.instance()
	add_child(dailyCoinsRef)
	
	if Global.isLevelScene:
		Global.isEndlessMode = false
		levelRef.find_node("Level").toggle_menu()
	
	if not SavedGames.saveGameDict["rated"] and int(SavedGames.saveGameDict["maxUnlockedLevel"])%5 == 0 and not Global.rateButtonShown:
		Global.rateButtonShown = true
		rateRef.show_rate_us_dialog()
	
	if not SavedGames.saveGameDict["shared"] and int(SavedGames.saveGameDict["maxUnlockedLevel"])%11 == 0 and not Global.shareButtonShown:
		Global.shareButtonShown = true
		shareRef.show_share_dialog()
	
	print("Printing load game shown boolean value")
	print(Global.loadGameShown)
	if not SavedGames.load_game_state() and not Global.loadGameShown:
		Global.loadGameShown = true
		loadPreviousGameRef.toggle_menu()
	
	play_background_sound()
	
	GooglePlay.sign_in()

func _process(_delta):
	var _currentTime = OS.get_unix_time()
	var _diff = _currentTime - SavedGames.saveGameDict["lastDailyRewardDate"]
	if _diff > 86400:
		find_node("DailyRewardButton").disabled = false
		find_node("DailyRewardTime").text = "Collect"
		find_node("RewardAnimation").play("daily_reward_animation")
	else:
		find_node("DailyRewardButton").disabled = true
		find_node("RewardAnimation").stop()
		
		var nextAt = (SavedGames.saveGameDict["lastDailyRewardDate"] + 86400) - (_currentTime)
		var nextAtHour = nextAt / 3600
		var nextAtMinutes = int(nextAt % 3600) / 60
		var nextAtSeconds = int ((nextAt % 3600) % 60)
		
		find_node("DailyRewardTime").text = "%s:%s:%s" % [nextAtHour,nextAtMinutes,nextAtSeconds]


func _unlock_endless_mode():
	#Disabling the endless mode if level is < 8
	if int(SavedGames.saveGameDict["maxUnlockedLevel"]) < 10:
		find_node("EndlessMode").disabled = true
		find_node("replay_green").disabled = true
		find_node("EndlessModeLabel").visible = false
		find_node("EndlessModeLabelLocked").visible = true
		find_node("EndlessModeLockedText").visible = true
		find_node("replay_green").texture_normal = endlessModeImage
	else:
		find_node("EndlessMode").disabled = false
		find_node("replay_green").disabled = false
		find_node("EndlessModeLockedText").visible = false
		find_node("EndlessModeLabel").visible = true
		find_node("EndlessModeLabelLocked").visible = false

func _on_Start_pressed():
	play_button_click_sound()
	levelRef.find_node("Level").toggle_menu()


func _on_Save_Game_button_up():
	print("Save game button clicked")
	GooglePlay.save_game()


func _on_Load_Game_button_up():
	print("Load game button clicked")
	GooglePlay.show_saved_games()



func _on_Save_Game_State_button_up():
	SavedGames.save_game_state()


func _on_EndlessMode_pressed():
	play_button_click_sound()
	yield(get_tree().create_timer(0.13), "timeout")
	Global.level = int(500)
	Global.isEndlessMode = true
	Global.goto_scene("res://Scenes/Play/PlayScene.tscn", self)


func _on_LeaderBoardButton_button_up():
	play_button_click_sound()
	yield(get_tree().create_timer(0.5), "timeout")
	GooglePlay.log_in_from_buttons()
	
	var highScore = SavedGames.saveGameDict["new_values"].get("high_score",0)
	GooglePlay.submit_leaderboard_score(highScore)
	
	GooglePlay.show_leaderboard()


func _on_AchievementButton_button_up():
	play_button_click_sound()
	yield(get_tree().create_timer(0.5), "timeout")
	GooglePlay.log_in_from_buttons()
	GooglePlay.show_achievements()


func _on_StoreButton_button_up():
	play_button_click_sound()
	storeRef.toggle_menu()


func _on_AdMob_rewarded(currency, ammount):
	#admob.load_rewarded_video()
	if storeGetCoinsAd:
		storeGetCoinsAd = false
		var coins = int(sqrt(float(SavedGames.saveGameDict["maxUnlockedLevel"])) * 500)
		SavedGames.saveGameDict["coins"] += coins
		SavedGames.save_game_state()
		storeRef.play_coins_sound()
	
func play_button_click_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$NormalButtonClick.play()

func play_background_sound():
	if SavedGames.saveGameDict["musicEnabled"]:
		 $BackgroundAudio.play()
	else:
		$BackgroundAudio.stop()


func _on_play_green_button_up():
	play_button_click_sound()
	levelRef.find_node("Level").toggle_menu()


func _on_replay_green_button_up():
	play_button_click_sound()
	yield(get_tree().create_timer(0.13), "timeout")
	Global.level = int(500)
	Global.isEndlessMode = true
	Global.goto_scene("res://Scenes/Play/PlayScene.tscn", self)


func _on_SettingsButton_button_up():
	play_button_click_sound()
	settingsRef.toggle()

# Handling back button press
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if storeRef.toggleMenu:
			storeRef.toggle_menu()
		elif levelRef.find_node("Level").toggleMenu:
			levelRef.find_node("Level").toggle_menu()
		else:
			quitGameRef.toggle_menu()
		


func _on_DailyRewardButton_button_up():
	dailyCoinsRef.give_reward()
