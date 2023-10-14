extends Control

var storeScene = preload("res://Scenes/Level/Store.tscn")
var tileUnlockScene = preload("res://Scenes/Play/TileUnlock.tscn")
var storeRef
var tileUnlockRef
var sceneRoot
var playScene

func _ready():
	sceneRoot = get_parent().get_parent()
	playScene = sceneRoot.get_parent()
	storeRef = storeScene.instance()
	tileUnlockRef = tileUnlockScene.instance()
	add_child(storeRef)
	add_child(tileUnlockRef)

func _process(_delta):
	var _double_coins_node = find_node("DoubleCoinsVideo")
	if _double_coins_node.disabled:
		_double_coins_node.visible = false
	else:
		_double_coins_node.visible = true


func end_level():
	storeRef.find_node("PotionsScreen").update_potions_count()
	storeRef.find_node("PotionsScreen").start()
	find_node("CoinsEarned").text = "Coins Earned : %s" % playScene.coinsEarned
	
	#Coin Multiplier Options
	if int(SavedGames.saveGameDict["multiplier"]) > 1:
		find_node("CoinMultiplier").visible = true
	else:
		find_node("CoinMultiplier").visible = false
	find_node("CoinMultiplier").text = "x%s Multiplier Applied" % SavedGames.saveGameDict["multiplier"]
	
	if SavedGames.saveGameDict["soundEnabled"]:
		find_node("LevelCompleteAudio").play()
	find_node("LevelCompleteAnimation").play("level_complete")
	
	sceneRoot.find_node("BackgroundTint").visible = true
	
	yield(get_tree().create_timer(0.5), "timeout")
	tileUnlockRef.check_unlock()
	
	if SavedGames.saveGameDict["maxUnlockedLevel"] == Global.level:
		SavedGames.saveGameDict["maxUnlockedLevel"] += 1
	SavedGames.save_game_state()

func unpause():
	self.visible = false
	sceneRoot.find_node("BackgroundTint").visible = false
	#get_tree().paused = false


func _on_Home_button_up():
	playScene.play_button_click_sound()
	unpause()
	if not Global.isEndlessMode:
		Global.isLevelScene = true
	Global.goto_scene("res://Scenes/HomeScene/HomeScene.tscn", playScene)

func _on_NextLevel_button_up():
	playScene.play_button_click_sound()
	unpause()
	Global.level += 1
	if Global.level > 50:
		Global.goto_scene("res://Scenes/Play/GameCompletedScene.tscn", playScene)
	else:
		Global.goto_scene("res://Scenes/Play/IntermediateScene.tscn", playScene)


func _on_Store_button_up():
	playScene.play_button_click_sound()
	storeRef.toggle_menu()


func _on_DoubleCoinsVideo_button_up():
	playScene.play_button_click_sound()
	
	if playScene.admob.is_rewarded_video_loaded():
		playScene.admob.show_rewarded_video()
		playScene.doubleCoinsAd = true
	else:
		#playScene.admob.load_rewarded_video()
		playScene.adNotLoadedRef.toggle()
	
	
